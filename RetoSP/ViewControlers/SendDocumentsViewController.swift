//
//  EnviarDocumentosViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//

import UIKit
import DropDown

class SendDocumentsViewController: UIViewController {

    @IBOutlet weak var selectDocument: UIView!
    
    let idTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
        "Cédula",
        "Cédula de extranjería",
        "Pasaporte",
        "Tarjeta de identidad"
        ]
        
        return menu
    }()
    
    let cityTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
        "Bogotá",
        "Medellín",
        "Lima",
        "Panamá",
        "México",
        "New Jersey",
        "Santiago de Chile"
        ]
        
        return menu
    }()
    
    let attachmentTypeMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
        "Incapacidad",
        "Factura",
        "Otro"
        ]
        
        return menu
    }()
    
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var cityLabel: UIButton!
    @IBOutlet weak var attachmentLabel: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        selectDocument.setOnClickListener {
            self.idTypeMenu.show()
        }
        idTypeMenu.anchorView = selectDocument
        idTypeMenu.selectionAction = { _, selected in
            self.documentTypeLabel.text = selected
        }
    }
    
    @IBAction func selectCityTapped(_ sender: Any) {
        self.cityTypeMenu.show()
        cityTypeMenu.anchorView = cityLabel
        cityTypeMenu.selectionAction = { _, selected in
            self.cityLabel.setTitle(selected, for: .normal)
        }
    }
    
    @IBAction func attachmentTypeTapped(_ sender: Any) {
        self.attachmentTypeMenu.show()
        attachmentTypeMenu.anchorView = attachmentLabel
        attachmentTypeMenu.selectionAction = { _, selected in
            self.attachmentLabel.setTitle(selected, for: .normal)
        }
    }
    
    
}

class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}

extension UIView {
    
    func setOnClickListener(action :@escaping () -> Void) {
        let tapRecognizer = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecognizer.onClick = action
        self.addGestureRecognizer(tapRecognizer)
    }
     
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
     
}
