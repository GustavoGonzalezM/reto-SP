//
//  MainMenu.swift
//  RetoSP
//
//  Created by Usuario on 27/12/22.
//

import UIKit
import DropDown

public class MainMenu {
    var shared = MainMenu()
    var mainMenu: DropDown = DropDown()
    var appearanceMode = UIScreen.main.traitCollection.userInterfaceStyle.rawValue
    var appearanceText: String = ""
    var menuDatasource = [
        "Enviar documentos",
        "Ver Documentos",
        "Oficinas",
        "Modo",
        "Idioma Inglés"
        ]

    func setupAppearanceText(_ appearance: String) {
        menuDatasource[3] = "Modo \(appearance)"
        
    }
}
