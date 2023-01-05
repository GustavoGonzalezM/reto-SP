//
//  ViewDocumentViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 4/01/23.
//

import UIKit

class ViewDocumentViewController: UIViewController {
    
    var image = UIImage(systemName: "arrow.left")
    
    @IBOutlet weak var viewDocument: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDocument.image = image
    }
}
