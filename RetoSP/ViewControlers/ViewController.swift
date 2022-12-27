//
//  ViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 26/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var eyeImage: UIButton!
    
    var networking = NetworkingProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.biometricButton.layer.cornerRadius = 10.0
        self.biometricButton.isEnabled = userIsEnrolled()
        self.biometricButton.layer.borderWidth = 1.0
       
        self.emailTextField.backgroundColor = UIColor.white
        self.emailContainerView.layer.borderColor = UIColor(named: "loginTextFields")?.cgColor
        self.emailContainerView.layer.borderWidth = 1.0
        self.emailContainerView.layer.cornerRadius = 10.0
        
        self.passwordTextField.backgroundColor = UIColor.white
        self.passwordContainerView.layer.borderColor = UIColor(named: "loginTextFields")?.cgColor
        self.passwordContainerView.layer.borderWidth = 1.0
        self.passwordContainerView.layer.cornerRadius = 10.0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "loginTextFields") ?? UIColor.gray
        ]
        
        let emailTextFieldAttributedText = NSAttributedString(string: "Email", attributes: attributes)
        self.emailTextField.attributedPlaceholder = emailTextFieldAttributedText
        
        let passwordTextFieldAttributedText = NSAttributedString(string: "Password", attributes: attributes)
        self.passwordTextField.attributedPlaceholder = passwordTextFieldAttributedText
        
    }
    
    @IBAction func eyeImageTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        let image = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
        self.eyeImage.setImage(image, for: .normal)
        
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
                        self.biometricButton.isEnabled = true
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
    
    func isEmailValid() -> Bool {
        let email = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return email.evaluate(with: self.emailTextField.text)
    }
    
    func generateAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func userIsEnrolled() -> Bool { UserDefaults.standard.bool(forKey: "enrolled") }
    
}

