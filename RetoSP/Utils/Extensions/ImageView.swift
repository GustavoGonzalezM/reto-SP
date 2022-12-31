//
//  ImageView.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 31/12/22.
//

import Foundation
import UIKit

extension UIImage {
    var convertToBase64: String? {
        self.jpegData(compressionQuality: 0)?.base64EncodedString()
    }
}

extension String {
    var convertFromBase64: UIImage? {
        guard let imageInBase64 = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageInBase64)
    }
}
