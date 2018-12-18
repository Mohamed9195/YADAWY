//
//  HomeViewController.swift
//  YADWY
//
//  Created by mohamed hashem on 12/16/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

   
    @IBOutlet weak var collectionHome: UICollectionView!
    
    let HomeCategory : [String] = ["clothes" ,"textiles" ,"houseware", "furniture", "beauty", "accessories", "electronics", "toys", "Food", "decoration", "other"]
   
    var path = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

// MARK: - Extension
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        return HomeCategory.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionHome.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
      editeCell(cell: cell)
       // cell.frame.size.width = collectionView.frame.size.width / 3
        cell.lableHome.text = HomeCategory[indexPath.row]
        cell.photoHome.image = UIImage(named: HomeCategory[indexPath.row])
        
//        cell.photoHome.layer.borderWidth = 0.5
//        cell.photoHome.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
//        cell.photoHome.layer.cornerRadius = 10
        
return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        path = indexPath.row
       performSegue(withIdentifier: "t", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "t" {
            let vc = segue.destination as! PostHomeViewController
            vc.Category = HomeCategory[path]
        }
    }
    
    
    
    
    func editeCell(cell: UICollectionViewCell){
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        cell.layer.cornerRadius = 10
    }
}
