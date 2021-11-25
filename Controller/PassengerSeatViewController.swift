//
//  PassengerSeatViewController.swift
//  Ibus
//
//  Created by Abdullah Al Alave on 11/29/19.
//  Copyright © 2019 Abdullah Al Alave. All rights reserved.
//

import UIKit
import Firebase

class PassengerSeatViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    let cellID = "cellID"
    
    var uuid: NSString = ""
    
    let itemText = ["A1","A2","A3","A4",
                    "B1","B2","B3","B4",
                    "C1","C2","C3","A4",
                    "D1","D2","D3","D4",
                    "E1","E2","E3","E4",
                    "F1","F2","F3","F4",
                    "G1","G2","G3","G4",
                    "H1","H2","H3","H4",
                    "I1","I2","I3","I4",
                    "J1","J2","J3","J4",
                    "K1","K2","K3","K4",
                    "K5","EX1","EX2"]
    
    var seatOccupied = [false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false,false,
                        false,false,false]
    
    
    lazy var collecTionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var collection = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
        
    }()
    
    
    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("supervisors").child(uuid as String).child("seat_data").observeSingleEvent(of: .value) { (snapshot) in
            guard let seat_data = snapshot.value as? [Bool] else { return }
            
            self.seatOccupied = seat_data
            self.setUpViews()
        }
        if(firstTime){
            
            firstTime = false
            
            Database.database().reference().child("supervisors").child(uuid as String).child("seat_data").observe(DataEventType.value, with: {(snapShot) in
                
                 guard let seat_data = snapShot.value as? [Bool] else { return }
                
                 self.seatOccupied = seat_data
                
                 self.collecTionView.reloadData()
            })
        }
        
    }
    
    func setUpViews() {
        view.backgroundColor = .white
        
        collecTionView.delegate = self
        collecTionView.dataSource = self
        
        navigationItem.title = "Seat Data"
        navigationController?.navigationBar.backgroundColor = .darkGray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        view.addSubview(collecTionView)
        
        collecTionView.translatesAutoresizingMaskIntoConstraints = false
        collecTionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collecTionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collecTionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collecTionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collecTionView.register(SeatCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SeatCell
        cell.descriptionLabel.text = itemText[indexPath.item]
        cell.backgroundColor = seatOccupied[indexPath.item] ? .red : .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width/4)-16, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

}
