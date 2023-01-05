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
    
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    var mainMenu: DropDown = DropDown()
    var appearanceMode: Int = 0
    var appearanceText: String = ""
    var menuDatasource = [
        "Enviar documentos",
        "Ver Documentos",
        "Oficinas",
        "Modo",
        "Idioma Inglés"
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        self.hideKeyboardWhenTappedOutside() 
        guard let user: User = UserDefaults.standard.retrieveCodable(for: "user") else { return }
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "default")
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: user.nombre)
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
        
        appearanceMode = osTheme.rawValue
        appearanceText = appearanceMode == 1 ? "nocturno" : "día"
        mainMenu.backgroundColor = UIColor(named: "background")
        mainMenu.textColor = UIColor(named: "default") ?? .label
        setupAppearanceText(appearanceText)
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
                print("Modo inglés seleccionado")
            default:
                print(index)
            }
        }
        mainMenu.dataSource = menuDatasource
        mainMenu.show()
    }
    
    func setAppearance() {
        if self.appearanceMode == 1 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("día")
            self.appearanceMode = 2
            
            
        } else if self.appearanceMode == 2 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("nocturno")
            self.appearanceMode = 1
           
        }
    }
    
    func setupAppearanceText(_ appearance: String){
        menuDatasource[3] = "Modo \(appearance)"
    }
}
