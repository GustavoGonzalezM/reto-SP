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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        appearanceMode = osTheme.rawValue
        appearanceText = appearanceMode == 1 ? "nocturno" : "día"
        mainMenu.backgroundColor = UIColor(named: "background")
        mainMenu.textColor = UIColor(named: "default") ?? .label
        setupAppearanceText(appearanceText)
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
                    print("Modo inglés seleccionado")
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
}
