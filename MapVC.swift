//
//  ViewController.swift
//  TrashCoin
//
//  Created by Finlay Nathan on 10/26/19.
//  Copyright © 2019 Finlay Nathan. All rights reserved.
//

import UIKit
import MapKit
import FanMenu
import Macaw
import CoreLocation
import PopupDialog

class MapVC: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fanMenu: FanMenu!
    var imagePicker: UIImagePickerController!
    var locationManager: CLLocationManager?
    var array1: [String] = []
    var money: Float! = 0
    
    let items = [
        ("camera", 0x969696),
        ("exclamationmark.bubble", 0xF02020),
        ("person.circle", 0x10BDDD),
        ("location", 0x45D300),
    ]
    
    var points = [
        ["title": "Trash Pile",    "latitude": 34.022294, "longitude": -118.390348],
        ["title": "Litter", "latitude": 33.934886, "longitude": -118.142197],
        ["title": "Lot of Junk",     "latitude": 33.890012, "longitude": -118.225560],
        ["title": "Trash Pile",    "latitude": 33.927971, "longitude": -118.384878],
        ["title": "Litter", "latitude": 33.845092, "longitude": -118.308808]
    ]
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      checkLocationAuthorizationStatus()
        thing()
        if let testArray = UserDefaults.standard.object(forKey: "images") as? [String] {
            self.array1 = testArray
        } else {
        }
        
        if let testMoney = UserDefaults.standard.object(forKey: "money") as? Float {
            self.money = testMoney
            let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"TC$\(String(describing: money!))",
                                                               style:UIBarButtonItem.Style.plain,
                                               target:self,
                                               action:#selector(someAction(_:)))
            logoutButton.tintColor = UIColor.white
            self.navigationItem.setLeftBarButton(logoutButton, animated:false)
        } else {
            let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"TC$0.00",
                                                               style:UIBarButtonItem.Style.plain,
                                               target:self,
                                               action:#selector(someAction(_:)))
            logoutButton.tintColor = UIColor.white
            self.navigationItem.setLeftBarButton(logoutButton, animated:false)
        }
        
    }
    
    func thing() {
        var currentLocation: CLLocation!

        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){

            currentLocation = locationManager?.location
            let initialLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            centerMapOnLocation(location: initialLocation)
        }
        
          
        for point in points {
            let annotation = MKPointAnnotation()
            annotation.title = point["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: point["latitude"] as! Double, longitude: point["longitude"] as! Double)
            mapView.addAnnotation(annotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let testArray = UserDefaults.standard.object(forKey: "images") as? [String] {
            self.array1 = testArray
        } else {
        }
        
        if let testMoney = UserDefaults.standard.object(forKey: "money") as? Float {
            self.money = testMoney
            let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"TC$\(String(describing: money!))",
                                                               style:UIBarButtonItem.Style.plain,
                                               target:self,
                                               action:#selector(someAction(_:)))
            logoutButton.tintColor = UIColor.white
            self.navigationItem.setLeftBarButton(logoutButton, animated:false)
        } else {
            let logoutButton:UIBarButtonItem = UIBarButtonItem(title:"TC$0.00",
                                                               style:UIBarButtonItem.Style.plain,
                                               target:self,
                                               action:#selector(someAction(_:)))
            logoutButton.tintColor = UIColor.white
            self.navigationItem.setLeftBarButton(logoutButton, animated:false)
        }
        
        
        let navigationBar = self.navigationController?.navigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(red:0.95, green:0.63, blue:0.22, alpha:1.0)
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        
        let myView = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))
        self.mapView.addGestureRecognizer(myView)
        
        
        let initialLocation = CLLocation(latitude: 34.052135, longitude: -118.243498)
        centerMapOnLocation(location: initialLocation)
        
        fanMenu.button = FanMenuButton(
            id: "main",
            image: UIImage(systemName: "line.horizontal.3"),
            color: Color(val: 0xF39F39)
        )
        
        fanMenu.items = items.map { button in
            FanMenuButton(
                id: button.0,
                image: UIImage(systemName: "\(button.0).fill"),
                color: Color(val: button.1)
            )
        }
        
        fanMenu.menuRadius = 90.0
        fanMenu.duration = 0.2
        fanMenu.delay = 0.05
        fanMenu.interval = (Double.pi, 2 * Double.pi)

        fanMenu.onItemDidClick = { button in
            if button.id == "camera" {
                self.imagePicker =  UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera

                self.present(self.imagePicker, animated: true, completion: nil)
            } else if button.id == "location" {
                var currentLocation: CLLocation!

                if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                        CLLocationManager.authorizationStatus() ==  .authorizedAlways){

                    currentLocation = self.locationManager?.location
                    let initialLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                    self.centerMapOnLocation(location: initialLocation)
                }
            } else if button.id == "exclamationmark.bubble" {

                // Prepare the popup assets
                let title = "REPORT TRASH"
                let message = "Too much trAaaaAAAaAAAaaSH??? Request help!"

                // Create the dialog
                let popup = PopupDialog(title: title, message: message)

                // Create buttons
                let buttonOne = CancelButton(title: "CANCEL") {
                }

                let buttonThree = DefaultButton(title: "REPORT", height: 60) {
                    
                    if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                        var currentLocation: CLLocation!
                        currentLocation = self.locationManager?.location
                        let initialLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                        self.centerMapOnLocation(location: initialLocation)
                        self.points.append(["title": "Litter", "latitude": currentLocation.coordinate.latitude, "longitude": currentLocation.coordinate.longitude])
                        self.thing()
                    }
                }

                // Add buttons to dialog
                // Alternatively, you can use popup.addButton(buttonOne)
                // to add a single button
                popup.addButtons([buttonOne, buttonThree])

                // Present dialog
                self.present(popup, animated: true, completion: nil)
            } else if button.id == "person.circle" {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                        self.present(newViewController, animated: true, completion: nil)
            }
        }

        fanMenu.onItemWillClick = { button in
            print("ItemWillClick: \(button.id)")
        }
        
        fanMenu.backgroundColor = .clear
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fanMenu.updateNode()
    }
    
    let regionRadius: CLLocationDistance = 20000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        fanMenu.close()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        saveImage(image: info[.originalImage] as! UIImage)
        //imageView.image = info[.originalImage] as? UIImage
    }
    
    @IBAction func test(_ sender: Any) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)

        } catch {
            print(error)
        }
    }
    
    
    func saveImage(image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyddMMHHmmss"
        
        let fileName = dateFormatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        array1.append(fileName)
        UserDefaults.standard.set(array1, forKey : "images")
        UserDefaults.standard.set(money+1, forKey : "money")
        
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }

            }

            do {
                try data.write(to: fileURL)
                print("image saved i guesss")
                
            } catch let error {
                print("error saving file with error", error)
            }

    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }

    func checkLocationAuthorizationStatus() {
      if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
        mapView.showsUserLocation = true
      } else {
        locationManager!.requestWhenInUseAuthorization()
      }
    }

}


