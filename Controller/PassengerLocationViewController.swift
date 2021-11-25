//
//  PassengerLocationViewController.swift
//  Ibus
//
//  Created by Abdullah Al Alave on 11/29/19.
//  Copyright © 2019 Abdullah Al Alave. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PassengerLocationViewController: UIViewController {
    
    var uuid: NSString = ""
    
    lazy var mapView:MKMapView = {
        var mv = MKMapView()
        
        return mv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        locationHandler()
    }
    func locationHandler(){
        Database.database().reference().child("supervisors").child(uuid as String).child("loc_data").observe(DataEventType.value, with: {(snapShot) in
            
            guard let loc_data = snapShot.value as? [Double] else { return }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = loc_data[0]
            annotation.coordinate.longitude = loc_data[1]
            
            self.mapView.showAnnotations([annotation], animated: true)
            
        })
        
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
        
        /// view defination
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    

}
