//
//  String.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 5/01/23.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
