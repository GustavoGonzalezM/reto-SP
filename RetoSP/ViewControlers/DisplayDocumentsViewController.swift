//
//  DisplayDocumentsViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//

import UIKit
import Foundation
import DropDown

class DisplayDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let networking = NetworkingProvider()
    var documents = Documents(items: [Document]())
    var image = UIImage()
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
        networking.getDocuments { result in
            DispatchQueue.main.async{
                self.documents = result
                self.tableView.reloadData()
            }
        } failure: { error in
            print("Error")
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupUI()
        
    }
    
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        appearanceMode = UserDefaults.standard.integer(forKey: "appearance")
        appearanceText = appearanceMode == 1 ? "mainMenu.nightMode".localized() : "mainMenu.dayMode".localized()
        setupAppearanceText(appearanceText)
        setInitialAppearance()
        if let currentLanguage = NSLocale.preferredLanguages.first{
            self.setupLanguageText(currentLanguage)
        }
    }
    
    @objc func menu() {
        mainMenu.anchorView = self.navigationItem.rightBarButtonItem
        mainMenu.bottomOffset = CGPoint(x: 0, y: 30)
        mainMenu.selectionAction = { index, _ in
            switch index {
                case 0:
                    self.performSegue(withIdentifier: "SendDocumentsSegue", sender: self)
                case 1:
                    print(index)
                case 2:
                    self.performSegue(withIdentifier: "LocateOfficesSegue", sender: self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = documents.items?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        guard let dateString = documents.items?[indexPath.row].date else { return cell }
        let date = formatDate(date: dateString)
       
        let labelString = "\(date) - \(documents.items?[indexPath.row].attachmentType ?? "")\n\(documents.items?[indexPath.row].name ?? "") \(documents.items?[indexPath.row].lastname ?? "")"
        cell.label.text = labelString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        networking.viewDocument(documentId: documents.items?[indexPath.row].documentId ?? "") { document in
            guard let imageInBase64 = document.items?[0].attachment else { return }
            if let image = imageInBase64.convertFromBase64 {
                DispatchQueue.main.async {
                    self.image = image
                    self.performSegue(withIdentifier: "ViewDocument", sender: self)
                }
            }
            
        } failure: { error in
            DispatchQueue.main.async {
                print("Error")
                let alert = UIAlertController(title: "Error", message: "Error al cargar imagen", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(alert, animated: true)
            }
        }

    }
    
    func setInitialAppearance() {
        if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("mainMenu.dayMode".localized())
            UserDefaults.standard.set(2, forKey: "appearance")
            
        } else if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("mainMenu.nightMode".localized())
            UserDefaults.standard.set(1, forKey: "appearance")
        }
    }
    
    func setAppearance() {
        if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("mainMenu.dayMode".localized())
            UserDefaults.standard.set(2, forKey: "appearance")
            
        } else if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("mainMenu.nightMode".localized())
            UserDefaults.standard.set(1, forKey: "appearance")
        }
    }
    
    func setupAppearanceText(_ appearance: String){
        menuDatasource[3] = appearance
    }
    
    func formatDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let fullDate = formatter.date(from: date) else { return "" }
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: fullDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewDocument" {
            let viewController = segue.destination as? ViewDocumentViewController
            viewController?.image = self.image
        }
    }
    
    func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.dismissButton".localized(), style: .default))
        self.present(alert, animated: true)
    }
    
    func setupLanguageText (_ language: String) {
        if language == "es-US" {
            self.menuDatasource[4] = "mainMenu.englishLanguage".localized()
        } else if language == "en" {
            self.menuDatasource[4] = "mainMenu.spanishLanguage".localized()
        }
    }
}
