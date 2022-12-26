//
//  MainScreenViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 26/11/22.
//

import UIKit

class MenuScreenViewController: UIViewController {

    @IBOutlet weak var enviarDocumentosScrollView: UIScrollView!
    @IBOutlet weak var verDocumentosScrollView: UIScrollView!
    @IBOutlet weak var verOficinasScrollView: UIScrollView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        let user = retreiveUserInfo()
        self.userNameLabel.text = user.nombre
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "default")
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        
        self.enviarDocumentosScrollView.layer.cornerRadius = 10.0
        self.enviarDocumentosScrollView.layer.borderColor = UIColor(named: "sendDocuments")?.cgColor
        self.enviarDocumentosScrollView.layer.borderWidth = 1.0
        
        self.verDocumentosScrollView.layer.cornerRadius = 10.0
        self.verDocumentosScrollView.layer.borderColor = UIColor(named: "displayDocuments")?.cgColor
        self.verDocumentosScrollView.layer.borderWidth = 1.0

        self.verOficinasScrollView.layer.cornerRadius = 10.0
        self.verOficinasScrollView.layer.borderColor = UIColor(named: "offices")?.cgColor
        self.verOficinasScrollView.layer.borderWidth = 1.0
    }
    
    func retreiveUserInfo() -> User {
        let user: User? = UserDefaults.standard.retrieveCodable(for: "user")
        return user ?? User(id: nil, nombre: nil, apellido: nil, acceso: false, admin: nil, email: nil)
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
        print("Menu Tapped")
    }
    
}
