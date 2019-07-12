//
//  UIViewControllerExtension.swift
//  Continuum
//
//  Created by Darin Marcus Armstrong on 7/11/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) {
        let accountStatusAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        accountStatusAlert.addAction(dismissAction)
        present(accountStatusAlert, animated: true, completion: nil)
    }
}
