//
//  ProfileViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/15/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var tableData: UITableView!
    @IBOutlet weak var collectionphoto: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    let Authentication = Auth.auth()
    let database = Database.database()
    let storage = Storage.storage()
    var counter = 0
    var collectionphotoformData : [UIImage] = []
    let dataInCategory : [String] = ["clothes" ,"textiles" ,"houseware", "furniture", "beauty", "accessories", "electronics", "toys", "Food", "decoration", "other"]
    
    var locationManger = CLLocationManager()
    let photoArray: [String] = ["iuser.png" , "email.png" , "address.png" , "phone.png" , "work.png", "about.png"]
    
    var long = 0.0
    var late = 0.0
    var dataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thimsView()
        
        reteive()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
        self.profilePhoto.layer.cornerRadius = self.profilePhoto
            .frame.size.width / 2
        self.profilePhoto.clipsToBounds = true
        
        tableData.separatorStyle = .none
        tableData.rowHeight = UITableView.automaticDimension
        
        
        
    }
    
     //MARK: - style view
    func thimsView(){
        tableData.layer.borderWidth = 0.5
        tableData.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        tableData.layer.cornerRadius = 10
        
        collectionphoto.layer.borderWidth = 0.5
        collectionphoto.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        collectionphoto.layer.cornerRadius = 10
        
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        mapView.layer.cornerRadius = 10
        
        self.profilePhoto.layer.cornerRadius = self.profilePhoto
            .frame.size.width / 2
        self.profilePhoto.clipsToBounds = true
        self.profilePhoto.layer.borderWidth = 0.5
        self.profilePhoto.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        
        tableData.separatorStyle = .none
        tableData.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: - Retrive data
    func reteive(){
        
        guard let AuthUID = Authentication.currentUser?.uid else {return}
        let messageDB = database.reference(withPath: "profile").child("\(AuthUID)")
        
        messageDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String , String>
            self.dataArray.append(snapshotValue["Name"]!)
            self.dataArray.append(snapshotValue["Email"]!)
            self.dataArray.append(snapshotValue["Address"]!)
            self.dataArray.append(snapshotValue["phone"]!)
            self.dataArray.append(snapshotValue["Work-Type"]!)
            self.dataArray.append(snapshotValue["Description"]!)
            
            
            self.tableData.reloadData()
            
        })
        
        DispatchQueue.global().async {
            // photo
            let islandRef = self.storage.reference(withPath: "profilePhoto").child("\(self.Authentication.currentUser!.uid)")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if error != nil {
                    print("nnnnnnnnnnn")
                } else {
                    DispatchQueue.main.async {
                        self.profilePhoto.image = UIImage(data: data!)
                    }
                    
                }
            }
        }

        
     //******************************************************************
        //Download image for post
        
        DispatchQueue.global().async {
            self.database.reference(withPath: "counter").observe(.value , with: { (data) in
                self.counter = data.value as! Int
               
                for i in 0...self.counter - 1 {
                    guard let AuthUID = self.Authentication.currentUser?.uid else {return}
                    let messageDB = self.storage.reference(withPath: "post").child("\(AuthUID)").child("\(i)")
                    messageDB.getData(maxSize: 10 * 1024 * 1024) { data, error in
                        if error != nil{
                            
                        }
                        DispatchQueue.main.async {
                            self.collectionphotoformData.append(UIImage(data: data!)!)
                            self.collectionphoto.reloadData()
                            
                        }
                   
                     
                    }
                  
                }
                  print(self.collectionphotoformData)
            })
           
            
        }
         //***************************************************
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//********************************************************************
//MARK: - Extension table
extension ProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoUserTableViewCell
        cell.photo.image = UIImage(named: photoArray[indexPath.row])
        if dataArray.count != 0{
            cell.label.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableData.deselectRow(at: indexPath, animated: true)
    }
}



//********************************************************************
//MARK: - Extension for Map view
extension ProfileViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            late = location.coordinate.latitude
            long = location.coordinate.longitude
            
            reloadMap()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError("not found location")
    }
    func reloadMap(){
        
        
        let noLocation = CLLocationCoordinate2D(latitude: late, longitude: long)
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(viewRegion, animated: false)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = noLocation
        annotation.title = "work Home"
        annotation.subtitle = "her"
        mapView.addAnnotation(annotation)
        
    }
}



//********************************************************************
//MARK: - Extension for collection view
extension ProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return collectionphotoformData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionphoto.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! photoCollectionViewCell
        editeCell(cell: cell)
      cell.photo.image = collectionphotoformData[indexPath.row]
            return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            performSegue(withIdentifier: "tolist", sender: self)
        
        
    }
    
    
    
    
    
    
    func editeCell(cell: UICollectionViewCell){
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        cell.layer.cornerRadius = 10
    }
}




