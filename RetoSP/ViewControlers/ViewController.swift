//
//  ViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 26/11/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    
    var networking = NetworkingProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let user = retrieveUserInfo()
        biometricButton.isEnabled = true
        if user.acceso {
            biometricButton.isEnabled = true
        }
        
        self.biometricButton.layer.cornerRadius = 10.0
        self.biometricButton.layer.borderColor = UIColor(named: "default")?.cgColor
        self.biometricButton.layer.borderWidth = 1.0
        
        self.emailTextField.layer.cornerRadius = 10.0
        self.emailTextField.layer.borderColor = UIColor(named: "default")?.cgColor
        self.emailTextField.layer.borderWidth = 1.0
        
        self.passwordTextField.layer.cornerRadius = 10.0
        self.passwordTextField.layer.borderColor = UIColor(named: "default")?.cgColor
        self.passwordTextField.layer.borderWidth = 1.0
        
        let emailTextFieldAttributedText = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "default") ?? Color.gray])
        self.emailTextField.attributedPlaceholder = emailTextFieldAttributedText
        
        let passwordTextFieldAttributedText = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "default") ?? Color.gray])
        self.passwordTextField.attributedPlaceholder = passwordTextFieldAttributedText
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailTextField.text == "" {
            generateAlert(title: "Error", message: "El email no puede estar vacío")
        } else if passwordTextField.text == "" {
            generateAlert(title: "Error", message: "El password no puede estar vacío")
        } else if isEmailValid() == false {
            generateAlert(title: "Error", message: "El email no es válido")
        } else {
            networking.login(user: emailTextField.text!, password: passwordTextField.text!) { user in
                DispatchQueue.main.async {
                    if user.acceso == true {
                        let user = User(id: user.id, nombre: user.nombre, apellido: user.apellido, acceso: user.acceso, admin: user.admin, email: self.emailTextField.text)
                        UserDefaults.standard.storeCodable(user, key: "user")
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuScreenViewController") as! MenuScreenViewController
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                    } else {
                        self.generateAlert(title: "Error", message: "Usuario o contraseña incorrectos\nIntente de nuevo")
                    }
                }
            } failure: { error in
                DispatchQueue.main.async {
                    print(error!.localizedDescription)
                    self.generateAlert(title: "Error", message: "Error al conectar con el servidor\nInténtelo de nuevo más tarde")
                }
            }
        }
    }
    
    @IBAction func biometricButtonTapped(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuScreenViewController") as! MenuScreenViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func isEmailValid() -> Bool{
        let email = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return email.evaluate(with: self.emailTextField.text)
    }
    
    func generateAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func retrieveUserInfo() -> User{
        let user: User? = UserDefaults.standard.retrieveCodable(for: "user")
        return user ?? User(id: nil, nombre: nil, apellido: nil, acceso: false, admin: nil, email: nil)
    }
}

