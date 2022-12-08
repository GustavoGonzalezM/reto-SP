//
//  EnviarDocumentosViewController.swift
//  RetoSP
//
//  Created by Usuario on 30/11/22.
//

import UIKit
import DropDown

class EnviarDocumentosViewController: UIViewController {

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
    
    
    @IBOutlet weak var tipoDeDocumentoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectDocument.setOnClickListener {
            self.menu.show()
        }
        menu.anchorView = selectDocument
        menu.selectionAction = { _, seleccionado in
            self.tipoDeDocumentoLabel.text = seleccionado
        }
    }
    
}

class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}

extension UIView {
    
    func setOnClickListener(action :@escaping () -> Void){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }
     
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
     
}
