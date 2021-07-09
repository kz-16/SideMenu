//
//  FirstViewController.swift
//  SideMenuTest
//
//  Created by KZ on 08.07.2021.
//

import UIKit

class FirstViewController: UIViewController {
  
  let numberLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNav()
    setupView()
  }

  func setupNav() {
    self.navigationItem.title = "firstVC"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .plain, target: revealViewController(), action: #selector(openMenu))
  }
    
  func setupView() {
    
    view.addSubview(numberLabel)
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    numberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    numberLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    numberLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    numberLabel.textColor = .black
    numberLabel.text = "1"
    
  }
  
  @objc func openMenu() {
    revealViewController()?.openMenu()
  }

}

