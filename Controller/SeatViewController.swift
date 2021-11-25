//
//  SeatViewController.swift
//  Ibus
//
//  Created by Abdullah Al Alave on 11/29/19.
//  Copyright © 2019 Abdullah Al Alave. All rights reserved.
//

import UIKit
import Firebase

class SeatViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    let cellID = "cellID"
    
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
    
    lazy var saveButton:UIButton = {
        var button = UIButton()
        
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        button.setTitle("Save Seat Data", for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius=8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveSeatData),
                         for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    lazy var collecTionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var collection = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
        
    }()
    
    
    
    @objc func saveSeatData( sender:UIButton){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("supervisors").child(uid).child("seat_data").setValue(self.seatOccupied, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("Failed to update database values with error: ", error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("supervisors").child(uid).child("seat_data").observeSingleEvent(of: .value) { (snapshot) in
            guard let seat_data = snapshot.value as? [Bool] else { return }
            
            self.seatOccupied = seat_data
            self.setUpViews()
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
        view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        collecTionView.translatesAutoresizingMaskIntoConstraints = false
        collecTionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collecTionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor).isActive = true
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            if seatOccupied[indexPath.item] {
                cell.backgroundColor = .green
                seatOccupied[indexPath.item] = false
                collectionView.reloadItems(at: [indexPath])
            }
            else{
                cell.backgroundColor = .red
                seatOccupied[indexPath.item] = true
                collectionView.reloadItems(at: [indexPath])
            }
            
        }
    }

}

class SeatCell: UICollectionViewCell {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Sample text"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    func setUpViews(){
        self.backgroundColor =  .green
        addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
