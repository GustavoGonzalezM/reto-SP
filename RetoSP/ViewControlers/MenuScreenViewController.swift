//
//  MainScreenViewController.swift
//  RetoSP
//
//  Created by Usuario on 26/11/22.
//

import UIKit

class MenuScreenViewController: UIViewController {

    @IBOutlet weak var boton1: UIButton!
    
    @IBOutlet weak var enviarDocumentosScrollView: UIScrollView!
    
    @IBOutlet weak var verDocumentosScrollView: UIScrollView!
    
    @IBOutlet weak var verOficinasScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.enviarDocumentosScrollView.layer.cornerRadius = 10.0
        self.enviarDocumentosScrollView.layer.borderColor = UIColor(named: "enviarDocumentos")?.cgColor
        self.enviarDocumentosScrollView.layer.borderWidth = 1.0
        
        self.verDocumentosScrollView.layer.cornerRadius = 10.0
        self.verDocumentosScrollView.layer.borderColor = UIColor(named: "verDocumentos")?.cgColor
        self.verDocumentosScrollView.layer.borderWidth = 1.0

        self.verOficinasScrollView.layer.cornerRadius = 10.0
        self.verOficinasScrollView.layer.borderColor = UIColor(named: "verOficinas")?.cgColor
        self.verOficinasScrollView.layer.borderWidth = 1.0

    }
}
