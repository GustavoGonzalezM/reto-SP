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
    let networking = NetworkingProvider()
    
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    var mainMenu: DropDown = DropDown()
    var appearanceMode: Int = 0
    var appearanceText: String = ""
    var menuDatasource = [
        "mainMenu.sendDocuments".localized(),
        "mainMenu.displayDocuments".localized(),
        "mainMenu.offices".localized(),
        "mainMenu.nightMode".localized(),
        "mainMenu.englishLanguage".localized(),
        "mainMenu.logout".localized()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadOffices()

    }
    
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menu))
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        appearanceMode = UserDefaults.standard.integer(forKey: "appearance")
        appearanceText = appearanceMode == 1 ? "mainMenu.nightMode".localized() : "mainMenu.dayMode".localized()
        setupAppearanceText(appearanceText)
        setInitialAppearance()
        if let currentLanguage = NSLocale.preferredLanguages.first{
            self.setupLanguageText(currentLanguage)
        }
        
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
                    if let currentLanguage = NSLocale.preferredLanguages.first{
                        self.setupLanguageText(currentLanguage)
                    }
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                case 5:
                    let alert = UIAlertController(title: "alert.logoutTitle".localized(), message: "alert.logoutMessage".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "alert.dismissButton".localized(), style: .destructive, handler: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "alert.cancelButton".localized(), style: .cancel))
                    self.present(alert, animated: true)
                default:
                    print(index)
            }
        }
        mainMenu.dataSource = menuDatasource
        mainMenu.show()
    }
    
    func setInitialAppearance() {
        print("APPEARANCE \(UserDefaults.standard.integer(forKey: "appearance"))")
        if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("mainMenu.dayMode".localized())
            UserDefaults.standard.set(2, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
            
        } else if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("mainMenu.nightMode".localized())
            UserDefaults.standard.set(1, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
        }
    }
    
    func setAppearance() {
        if UserDefaults.standard.integer(forKey: "appearance") == 1 {
            print("APPEARANCE \(UserDefaults.standard.integer(forKey: "appearance"))")
            self.view.overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.tintColor = UIColor.white
            mainMenu.backgroundColor = UIColor(named: "mainMenu")
            mainMenu.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            self.setupAppearanceText("mainMenu.dayMode".localized())
            UserDefaults.standard.set(2, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
            
        } else if UserDefaults.standard.integer(forKey: "appearance") == 2 {
            self.view.overrideUserInterfaceStyle = .light
            mainMenu.backgroundColor = UIColor.white
            mainMenu.textColor = UIColor(named: "navigationBarDay") ?? .black
            self.navigationController?.navigationBar.tintColor = UIColor(named: "navigationBarDay")
            UIApplication.shared.statusBarStyle = .darkContent
            self.setupAppearanceText("mainMenu.nightMode".localized())
            UserDefaults.standard.set(1, forKey: "appearance")
            print("CHANGED TO \(UserDefaults.standard.integer(forKey: "appearance"))")
        }
    }
    
    func setupAppearanceText(_ appearance: String){
        menuDatasource[3] = appearance
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
    
    func loadOffices() {
        networking.getOffices() { sophos in
            DispatchQueue.main.async {
                sophos.offices.forEach { office in
                    guard var latitude = Double(office.latitude) else { return }
                    guard let longitude = Double(office.longitude) else { return }
                    
                    if office.city == "Chile" && latitude > 0 {
                        latitude = latitude * -1
                        
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = office.name
                    
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    annotation.coordinate = location
                    self.mapView.addAnnotation(annotation)
                    
                }
            }
        } failure: { error in
            DispatchQueue.main.async {
                print(error!.localizedDescription)
                self.generateAlert(title: "Error", message: "locateOffices.error.serverError".localized())
            }
        }
    }
    
    func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.dismissButton".localized(), style: .default))
        self.present(alert, animated: true)
    }
    
    func setupLanguageText (_ language: String) {
        if language == "es-US" {
            self.menuDatasource[4] = "mainMenu.englishLanguage".localized()
        } else if language == "en" {
            self.menuDatasource[4] = "mainMenu.spanishLanguage".localized()
        }
    }
}
