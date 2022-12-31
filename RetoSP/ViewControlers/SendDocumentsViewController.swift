//
//  EnviarDocumentosViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//

import UIKit
import DropDown

class SendDocumentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectDocument: UIView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var cityLabel: UIButton!
    @IBOutlet weak var attachmentLabel: UIButton!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userDocumentNumber: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var networking = NetworkingProvider()
    let imagePicker = UIImagePickerController()
    var imageInBase64 = String()
    let user: User = User(id: nil, nombre: nil, apellido: nil, acceso: true, admin: nil, email: nil)
    var missingFields = [String]()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        selectDocument.setOnClickListener {
            self.idTypeMenu.show()
        }
        idTypeMenu.anchorView = selectDocument
        idTypeMenu.selectionAction = { _, selected in
            self.documentTypeLabel.text = selected
        }
        loadOffices()
        imagePicker.delegate = self
        guard let user: User = UserDefaults.standard.retrieveCodable(for: "user") else { return }
        userName.text = user.nombre
        userLastName.text = user.apellido
        userEmail.text = user.email
        
    }
    
    func loadOffices() {
        networking.getOffices() { sophos in
            DispatchQueue.main.async {
                sophos.offices.forEach { office in
                    self.cityTypeMenu.dataSource.append(office.ciudad)
                }
            }
        } failure: { error in
            DispatchQueue.main.async {
                print(error!.localizedDescription)
                self.generateAlert(title: "Error", message: "Error al conectar con el servidor\nInténtelo de nuevo más tarde")
                
            }
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
    
    @IBAction func selectImageTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Seleccionar", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Tomar foto", style: .default){ _ in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cargar imagen de la galería", style: .default){ _ in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.selectImage.setImage(UIImage(), for: .normal)
        self.imagePicked.image = img
        if let img = img?.convertToBase64 {
            self.imageInBase64 = img
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        if validateEmptyFields() {
            print(imageInBase64)
            let newDocument: NewDocument = NewDocument(tipoId: documentTypeLabel.text!,
                                                       identificacion: userDocumentNumber.text!,
                                                       nombre: userName.text!,
                                                       apellido: userLastName.text!,
                                                       ciudad: (cityLabel.titleLabel?.text)!,
                                                       correo: userEmail.text!,
                                                       tipoAdjunto: (attachmentLabel.titleLabel?.text)!,
                                                       adjunto: imageInBase64)
            networking.uploadDocument(newDocument: newDocument) { response in
                if response {
                    print("OK")
                } else {
                    print("falló")
                }
            }
        } else {
            let missingFieldsResume = missingFields.joined(separator: "\n")
            let alert = UIAlertController(title: "Verificar", message: "Faltan:\n \(missingFieldsResume)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alert, animated: true)
        }
        
    }
    
    func validateEmptyFields() -> Bool {
        var result: Int = 0
        missingFields.removeAll()
        if self.imagePicked.image == nil {
            result += 1
            missingFields.append("Escoger imagen")
        }
        if !idTypeMenu.dataSource.contains(documentTypeLabel.text ?? "") {
            result += 1
            missingFields.append("Tipo de documento")
        }
        if userDocumentNumber.text == "" {
            result += 1
            missingFields.append("Número de documento")
        }
        if userName.text == "" {
            result += 1
            missingFields.append("Nombres")
        }
        if userLastName.text == "" {
            result += 1
            missingFields.append("Apellidos")
        }
        if userEmail.text == "" {
            result += 1
            missingFields.append("Email")
        }
        if !isEmailValid() {
            result += 1
            missingFields.append("Email no válido")
        }
        if !cityTypeMenu.dataSource.contains(cityLabel.titleLabel?.text ?? "") {
            result += 1
            missingFields.append("Escoger ciudad")
        }
        if !attachmentTypeMenu.dataSource.contains(attachmentLabel.titleLabel?.text ?? "") {
            result += 1
            missingFields.append("Escoger tipo de adjunto")
        }
        return result == 0
    }
    
    func isEmailValid() -> Bool {
        let email = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return email.evaluate(with: self.userEmail.text)
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
