//
//  MainScreenViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 26/11/22.
//

import UIKit
import DropDown

class MenuScreenViewController: UIViewController {

    @IBOutlet weak var sendDocumentsScrollView: UIScrollView!
    @IBOutlet weak var displayDocumentsScrollView: UIScrollView!
    @IBOutlet weak var locateOfficesScrollView: UIScrollView!
    @IBOutlet weak var sendDocumentsButton: UIButton!
    @IBOutlet weak var displayDocumentsButton: UIButton!
    @IBOutlet weak var locateOfficesButton: UIButton!
    @IBOutlet weak var sendDocumentsLabel: UILabel!
    @IBOutlet weak var displayDocumentsLabel: UILabel!
    @IBOutlet weak var officesLabel: UILabel!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    @IBOutlet weak var bannerCaptionLabel: UILabel!
    var mainMenu: DropDown = DropDown()
    var appearanceMode: Int = 0
    var appearanceText: String = ""
    var menuDatasource = [
        "mainMenu.sendDocuments".localized(),
        "mainMenu.displayDocuments".localized(),
        "mainMenu.offices".localized(),
        "mainMenu.nightMode".localized(),
        "mainMenu.englishLanguage".localized(),
        "mainMenu.logout".localized()
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocalization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialAppearance()

    }
    
    func setupUI(){
        self.hideKeyboardWhenTappedOutside() 
        guard let user: User = UserDefaults.standard.retrieveCodable(for: "user") else { return }
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "default")
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: user.name)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        
        self.sendDocumentsScrollView.layer.cornerRadius = 10.0
        self.sendDocumentsScrollView.layer.borderColor = UIColor(named: "sendDocuments")?.cgColor
        self.sendDocumentsScrollView.layer.borderWidth = 1.0
        
        self.displayDocumentsScrollView.layer.cornerRadius = 10.0
        self.displayDocumentsScrollView.layer.borderColor = UIColor(named: "displayDocuments")?.cgColor
        self.displayDocumentsScrollView.layer.borderWidth = 1.0

        self.locateOfficesScrollView.layer.cornerRadius = 10.0
        self.locateOfficesScrollView.layer.borderColor = UIColor(named: "offices")?.cgColor
        self.locateOfficesScrollView.layer.borderWidth = 1.0
        appearanceMode = UserDefaults.standard.integer(forKey: "appearance")
        appearanceText = appearanceMode == 1 ? "mainMenu.nightMode".localized() : "mainMenu.dayMode".localized()
        setupAppearanceText(appearanceText)
        setInitialAppearance()
        if let currentLanguage = NSLocale.preferredLanguages.first{
            self.setupLanguageText(currentLanguage)
        }
    }
    
    func setupLocalization(){
        sendDocumentsLabel.text = "menuScreen.sendDocumentsLabel".localized()
        displayDocumentsLabel.text = "menuScreen.displayDocumentsLabel".localized()
        officesLabel.text = "menuScreen.officesLabel".localized()
        bannerTitleLabel.text = "menuScreen.bannerTitleLabel".localized()
        bannerCaptionLabel.text = "menuScreen.bannerCaptionLabel".localized()
    }
    
    @IBAction func sendDocumentsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "SendDocumentsSegue", sender: self)
    }
    
    
    @IBAction func displayDocumentsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "DisplayDocumentsSegue", sender: self)
    }
    
    @IBAction func locateOfficesTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "LocateOfficesSegue", sender: self)
    }
    
    @objc func menu() {
        mainMenu.anchorView = self.navigationItem.rightBarButtonItem
        mainMenu.bottomOffset = CGPoint(x: 0, y: 30)
        mainMenu.selectionAction = { index, _ in
            switch index {
                case 0:
                    self.sendDocumentsTapped(self)
                case 1:
                    self.displayDocumentsTapped(self)
                case 2:
                    self.locateOfficesTapped(self)
                case 3:
                    self.setAppearance()
                case 4:
                    if let currentLanguage = NSLocale.preferredLanguages.first{
                        self.setupLanguageText(currentLanguage)
                    }
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                    
                case 5:
                    let alert = UIAlertController(title: "alert.logoutTitle".localized(), message: "alert.logoutMessage".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "alert.dismissButton".localized(), style: .destructive, handler: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "alert.cancelButton".localized(), style: .cancel))
                    self.present(alert, animated: true)
                default:
                    print(index)
            }
        }
        mainMenu.dataSource = menuDatasource
        mainMenu.show()
    }
    
    func setInitialAppearance() {
        print("APPEARANCE \(UserDefaults.standard.integer(forKey: "appearance"))")
        if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("mainMenu.dayMode".localized())
            UserDefaults.standard.set(2, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
            
        } else if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("mainMenu.nightMode".localized())
            UserDefaults.standard.set(1, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
        }
    }
    
    func setAppearance() {
        print("APPEARANCE \(UserDefaults.standard.integer(forKey: "appearance"))")
        if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("mainMenu.dayMode".localized())
            UserDefaults.standard.set(2, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
            
        } else if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("mainMenu.nightMode".localized())
            UserDefaults.standard.set(1, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
        }
    }
    
    func setupAppearanceText(_ appearance: String){
        menuDatasource[3] = appearance
    }
    
    func setupLanguageText (_ language: String) {
        if language == "es-US" {
            self.menuDatasource[4] = "mainMenu.englishLanguage".localized()
        } else if language == "en" {
            self.menuDatasource[4] = "mainMenu.spanishLanguage".localized()
        }
    }
    
    func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.dismissButton".localized(), style: .default))
        self.present(alert, animated: true)
    }
}
