//
//  MainScreenViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 26/11/22.
//

import UIKit

class MenuScreenViewController: UIViewController {

    @IBOutlet weak var sendDocumentsScrollView: UIScrollView!
    @IBOutlet weak var displayDocumentsScrollView: UIScrollView!
    @IBOutlet weak var locateOfficesScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        guard let user: User = UserDefaults.standard.retrieveCodable(for: "user") else { return }
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "default")
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: user.nombre)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        
        self.sendDocumentsScrollView.layer.cornerRadius = 10.0
        self.sendDocumentsScrollView.layer.borderColor = UIColor(named: "sendDocuments")?.cgColor
        self.sendDocumentsScrollView.layer.borderWidth = 1.0
        
        self.displayDocumentsScrollView.layer.cornerRadius = 10.0
        self.displayDocumentsScrollView.layer.borderColor = UIColor(named: "displayDocuments")?.cgColor
        self.displayDocumentsScrollView.layer.borderWidth = 1.0

        self.locateOfficesScrollView.layer.cornerRadius = 10.0
        self.locateOfficesScrollView.layer.borderColor = UIColor(named: "offices")?.cgColor
        self.locateOfficesScrollView.layer.borderWidth = 1.0
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
