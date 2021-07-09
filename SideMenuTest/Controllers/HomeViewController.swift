//
//  HomeViewController.swift
//  SideMenuTest
//
//  Created by KZ on 08.07.2021.
//

import UIKit

class HomeViewController: UIViewController {
  
  var sideMenuViewController: SideMenuViewController!
  var sideMenuShadowView = UIView()
  let numberLabel = UILabel()
  
  var sideMenuExpandWidth: CGFloat!
  var panLocation: CGFloat = 0.0
  var isExpanded = false
  var sideMenuTrailingConstraint: NSLayoutConstraint!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNav()
    setupView()
  }

  func setupNav() {
    self.navigationItem.title = "homeVC"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .plain, target: self, action: #selector(openMenu))
  }
    
  func setupView() {
    view.backgroundColor = .white
    sideMenuExpandWidth = view.frame.width * (2/3)
    
    self.sideMenuShadowView = UIView(frame: self.view.bounds)
    self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.sideMenuShadowView.backgroundColor = .black
    self.sideMenuShadowView.alpha = 0
    view.insertSubview(self.sideMenuShadowView, at: 1)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.delegate = self
    view.addGestureRecognizer(tapGestureRecognizer)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    panGestureRecognizer.delegate = self
    view.addGestureRecognizer(panGestureRecognizer)
    
    sideMenuViewController = SideMenuViewController()
    sideMenuViewController.delegate = self
    view.insertSubview(sideMenuViewController!.view, at: 2)
    addChild(sideMenuViewController!)
    sideMenuViewController!.didMove(toParent: self)
    
    sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

    sideMenuTrailingConstraint = sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideMenuExpandWidth)
    sideMenuTrailingConstraint.isActive = true
    sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuExpandWidth).isActive = true
    sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

    showViewController(viewController: UINavigationController.self, vc: UINavigationController(rootViewController: FirstViewController()))

  }
  
  @objc func openMenu() {
    self.sideMenuState(expanded: self.isExpanded ? false : true)
  }

}

extension HomeViewController: SideMenuDelegate {
  
  func selectCell(row: Int) {
    switch row {
    case 0:
      self.showViewController(viewController: UINavigationController.self, vc: UINavigationController(rootViewController: FirstViewController()))
    case 1:
      self.showViewController(viewController: UINavigationController.self, vc: UINavigationController(rootViewController: SecondViewController()))
    case 2:
      self.showViewController(viewController: UINavigationController.self, vc: UINavigationController(rootViewController: ThirdViewController()))

    default:
      break
    }

    DispatchQueue.main.async { self.sideMenuState(expanded: false) }
  }
  
  func showViewController<T: UIViewController>(viewController: T.Type, vc: UIViewController) -> () {
    
    for subview in view.subviews {
      if subview.tag == 123 {
        subview.removeFromSuperview()
      }
    }
        
    vc.view.tag = 123
    view.insertSubview(vc.view, at: 0)
    addChild(vc)
    vc.didMove(toParent: self)
  }

  func sideMenuState(expanded: Bool) {
    if expanded {
        
      animateSideMenu(targetPosition: 0) { _ in
        self.isExpanded = true
      }
          
      UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.5 }
    } else {
      
      self.animateSideMenu(targetPosition: (-sideMenuExpandWidth)) { _ in
        self.isExpanded = false
      }
         
      UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
    }
  }

  func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
          
      self.sideMenuTrailingConstraint.constant = targetPosition
      self.view.layoutIfNeeded()
            
    }, completion: completion)
  }
}


extension HomeViewController: UIGestureRecognizerDelegate {
  @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
    if sender.state == .ended {
      if isExpanded {
        sideMenuState(expanded: false)
      }
    }
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if (touch.view?.isDescendant(of: sideMenuViewController.view))! {
      return false
    }
    return true
  }

  @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
          
     let velocity: CGFloat = sender.velocity(in: view).x
     let position: CGFloat = sender.translation(in: view).x

     switch sender.state {
     case .began:

       if velocity > 0 && isExpanded {
         sender.state = .cancelled
       }

       let velocityLimit: CGFloat = 550
       if abs(velocity) > velocityLimit {
         sideMenuState(expanded: isExpanded ? false : true)
         return
       }

       panLocation = 0.0
       if isExpanded {
         panLocation = sideMenuExpandWidth
       }

     case .changed:

       let xPosition: CGFloat = panLocation + position
       let percentage = (xPosition * 150 / sideMenuExpandWidth) / sideMenuExpandWidth

       let alpha = percentage >= 0.5 ? 0.5 : percentage
       sideMenuShadowView.alpha = alpha

       if xPosition <= sideMenuExpandWidth {
         sideMenuTrailingConstraint.constant = xPosition - sideMenuExpandWidth
       }
                    
     case .ended:
  
       let isMoreThanHalf = sideMenuTrailingConstraint.constant > -(sideMenuExpandWidth * 0.5)
       self.sideMenuState(expanded: isMoreThanHalf)
              
     default:
       break
     }
   }
}


