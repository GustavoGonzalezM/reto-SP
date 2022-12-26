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
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
        "Cédula",
        "Cédula de extranjería",
        "Pasaporte",
        "Tarjeta de identidad"
        ]
        
        return menu
    }()
    
    
    @IBOutlet weak var documentTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectDocument.setOnClickListener {
            self.menu.show()
        }
        menu.anchorView = selectDocument
        menu.selectionAction = { _, selected in
            self.documentTypeLabel.text = selected
        }
    }
    
}

class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}

extension UIView {
    
    func setOnClickListener(action :@escaping () -> Void){
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
