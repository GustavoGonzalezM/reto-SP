//
//  ViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 26/11/22.
//

import UIKit
import LocalAuthentication
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var eyeImage: UIButton!
    
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    let networking = NetworkingProvider()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: UIColor(named: "default"), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocalization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialAppearance()

    }
    
    func setupUI() {
        self.hideKeyboardWhenTappedOutside()
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
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 50),
            loading.heightAnchor.constraint(equalToConstant: 50),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.topAnchor.constraint(equalTo: biometricButton.bottomAnchor)
        ])
        UserDefaults.standard.set(osTheme.rawValue, forKey: "appearance")
        setInitialAppearance()
    }
    
    func setupLocalization(){
        self.loginButton.setTitle("login.loginButton".localized(), for: .normal)
        self.biometricButton.setTitle("login.biometricButton".localized(), for: .normal)
    }
    
    func setInitialAppearance() {
        print("APPEARANCE \(UserDefaults.standard.integer(forKey: "appearance"))")
        if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .dark
            UIApplication.shared.statusBarStyle = .lightContent
            UserDefaults.standard.set(2, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")

        } else if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            self.view.overrideUserInterfaceStyle = .light
            UIApplication.shared.statusBarStyle = .darkContent
            UserDefaults.standard.set(1, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
        }
    }

    @IBAction func eyeImageTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        let image = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
        self.eyeImage.setImage(image, for: .normal)
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailTextField.text == "" {
            generateAlert(title: "Error", message: "login.error.emptyEmail".localized())
        } else if passwordTextField.text == "" {
            generateAlert(title: "Error", message: "login.error.emptyPassword".localized())
        } else if isEmailValid() == false {
            generateAlert(title: "Error", message: "login.error.invalidEmail".localized())
        } else {
            loading.startAnimating()
            networking.login(user: emailTextField.text!, password: passwordTextField.text!) { user in
                DispatchQueue.main.async {
                    if user.access == true {
                        self.biometricButton.isEnabled = true
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuScreenViewController") as! MenuScreenViewController
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                    } else {
                        self.generateAlert(title: "Error", message: "login.error.invalidCredentials".localized())
                    }
                    self.loading.stopAnimating()
                }
            } failure: { error in
                DispatchQueue.main.async {
                    print(error!.localizedDescription)
                    self.generateAlert(title: "Error", message: "login.error.serverError".localized())
                    self.loading.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func biometricButtonTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "login.biometricReason".localized()
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        //failed
                        let alert = UIAlertController(title: "login.error.biometric.authenticationTitle".localized(), message: "login.error.biometric.authenticationMessage".localized(), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "login.error.biometric.authenticationButton".localized(),
                                                      style: .cancel,
                                                      handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    // Success
                    let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "MenuScreenViewController") as! MenuScreenViewController
                    self?.navigationController?.pushViewController(viewController,                                   animated: true)
                }
                
            }
        }
        else {
            // Can not use
            let alert = UIAlertController(title: "login.error.biometric.usageTitle".localized(), message: "login.error.biometric.usageMessage".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "login.error.biometric.usageButton".localized(),
                                          style: .cancel,
                                          handler: nil))
            present(alert, animated: true)
        }
        
        
    }
    
    func isEmailValid() -> Bool {
        let email = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return email.evaluate(with: self.emailTextField.text)
    }
    
    func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func userIsEnrolled() -> Bool { UserDefaults.standard.bool(forKey: "enrolled") }
    
}

