//
//  ViewController.swift
//  RetoSP
//
//  Created by Usuario on 26/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var biometricButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        print("Touch button Login")
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuScreenViewController") as! MenuScreenViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func biometricButtonTapped(_ sender: Any) {
        
        print("Touch button Biometric")
        
    }
    
}

