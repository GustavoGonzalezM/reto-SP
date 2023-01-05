//
//  VerOficinasViewController.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//

import UIKit
import MapKit
import CoreLocation
import DropDown

class LocateOfficesViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    var mainMenu: DropDown = DropDown()
    var appearanceMode: Int = 0
    var appearanceText: String = ""
    var menuDatasource = [
        "Enviar documentos",
        "Ver Documentos",
        "Oficinas",
        "Modo",
        "Idioma Inglés"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        appearanceMode = osTheme.rawValue
        appearanceText = appearanceMode == 1 ? "nocturno" : "día"
        mainMenu.backgroundColor = UIColor(named: "background")
        mainMenu.textColor = UIColor(named: "default") ?? .label
        setupAppearanceText(appearanceText)
    }
    
    @objc func menu() {
        mainMenu.anchorView = self.navigationItem.rightBarButtonItem
        mainMenu.bottomOffset = CGPoint(x: 0, y: 30)
        mainMenu.selectionAction = { index, _ in
            switch index {
                case 0:
                    self.performSegue(withIdentifier: "SendDocumentsSegue", sender: self)
                case 1:
                    self.performSegue(withIdentifier: "DisplayDocumentsSegue", sender: self)
                case 2:
                    print(index)
                case 3:
                    self.setAppearance()
                case 4:
                    print("Modo inglés seleccionado")
                default:
                    print(index)
            }
        }
        mainMenu.dataSource = menuDatasource
        mainMenu.show()
    }
    
    func setAppearance() {
        if self.appearanceMode == 1 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("día")
            self.appearanceMode = 2
            
            
        } else if self.appearanceMode == 2 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("nocturno")
            self.appearanceMode = 1
            
        }
    }
    
    func setupAppearanceText(_ appearance: String){
        menuDatasource[3] = "Modo \(appearance)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region,
                          animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
        
        
    }
}
