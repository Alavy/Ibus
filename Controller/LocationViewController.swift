//
//  LocationViewController.swift
//  Ibus
//
//  Created by Abdullah Al Alave on 11/28/19.
//  Copyright © 2019 Abdullah Al Alave. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class LocationViewController: UIViewController {
    
    private var locations:[MKPointAnnotation] = []
    
    private lazy var locationManager:CLLocationManager={
        let manager = CLLocationManager()
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestAlwaysAuthorization()
        
        manager.allowsBackgroundLocationUpdates = true
        
        return manager
    }()
    
    lazy var mapView:MKMapView = {
        var mv = MKMapView()
        
        return mv
    }()
    
    lazy var startUpdatingLocationButton:UIButton = {
        var button = UIButton()
        
        button.setTitle(button.isSelected ? "Stop Updating" : "Start Updating",
            for:.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius=8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startUpdatingLocationButtonAction),
                         for: .touchUpInside)
        return button
    }()
    @objc func startUpdatingLocationButtonAction( sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            locationManager.startUpdatingLocation()
        }
        else{
            locationManager.stopMonitoringVisits()
        }
        startUpdatingLocationButton.setTitle(startUpdatingLocationButton.isSelected ? "Stop Updating" : "Start Updating",
                        for:.normal)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Share Location"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        view.addSubview(mapView)
        view.addSubview(startUpdatingLocationButton)
        
        /// view defination
        startUpdatingLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        startUpdatingLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        startUpdatingLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startUpdatingLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: startUpdatingLocationButton.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    

}
extension LocationViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else{
            return
        }
        let loc : [Double] = [mostRecentLocation.coordinate.latitude , mostRecentLocation.coordinate.longitude]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("supervisors").child(uid).child("loc_data").setValue(loc, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("Failed to update database values with error: ", error.localizedDescription)
                return
            }
        })
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        self.locations.append(annotation)
        while locations.count > 6{
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active{
            self.mapView.showAnnotations(self.locations, animated: true)
        }else{
            print("App is in background mode at location : \(mostRecentLocation)")
        }
    }
}
