//
//  UIViewExtension.swift
//  SideMenuTest
//
//  Created by KZ on 09.07.2021.
//

import UIKit

extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> HomeViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is HomeViewController {
            return viewController! as? HomeViewController
        }
        while (!(viewController is HomeViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is HomeViewController {
            return viewController as? HomeViewController
        }
        return nil
    }
    
}
