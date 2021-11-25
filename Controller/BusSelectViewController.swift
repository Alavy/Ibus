//
//  BusSelectViewController.swift
//  Ibus
//
//  Created by Abdullah Al Alave on 12/1/19.
//  Copyright © 2019 Abdullah Al Alave. All rights reserved.
//

import UIKit
import Firebase


class BusSelectViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    let busId = "BusID"
    
    struct Bus{
        var name:String
        var route:String
        var supervisor:NSString
    }
    
    var buses:[Bus] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var collection = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
    }()
    
    var forLocationData:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("buses").observeSingleEvent(of: .value) { (snapshot) in
            guard let dataDic = snapshot.value as? [NSDictionary] else { return }
            
            for data in dataDic {
                let bus:Bus = Bus(name: data["name"] as! String, route:  data["route"] as! String, supervisor: data["supervisor"] as! NSString )
                self.buses.append(bus)
                print(bus)
            }
            self.setupViews()
        }
    }
    
    func setupViews(){
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        navigationItem.title = "Select Bus"
        navigationController?.navigationBar.backgroundColor = .darkGray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        collectionView.register(BusCell.self, forCellWithReuseIdentifier: busId)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return buses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: busId, for: indexPath) as! BusCell
        cell.nameLabel.text = buses[indexPath.item].name
        cell.routeLabel.text = buses[indexPath.item].route
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width)-16, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if forLocationData {
            
            let controller = PassengerLocationViewController()
            controller.uuid = buses[indexPath.item].supervisor
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
        else{
            
            let controller = PassengerSeatViewController()
            controller.uuid = buses[indexPath.item].supervisor
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
        
    }
}

class BusCell:UICollectionViewCell{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 26)
        label.text = "Sample text"
        return label
    }()
    
    let routeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Sample text"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    func setUpViews(){
        self.backgroundColor =  .purple
        self.layer.cornerRadius = 9
        
        addSubview(nameLabel)
        addSubview(routeLabel)
        
        routeLabel.translatesAutoresizingMaskIntoConstraints = false
        routeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        routeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: routeLabel.topAnchor).isActive = true
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
