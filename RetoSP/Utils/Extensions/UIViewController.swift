//
//  UIViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 2/01/23.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
