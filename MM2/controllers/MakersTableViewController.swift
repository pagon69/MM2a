//
//  MakersTableViewController.swift
//  MM2
//
//  Created by user147645 on 3/27/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import GoogleMobileAds


class MakersTableViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource{
   
    //collection vew setup
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewOutlet.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as! NewsCollectionViewCell
        
        cell.backgroundColor = .blue
        
        
        return cell
    }
    

    
    
    
    //globals
    var data: Markets?
    
    //outlets
    @IBOutlet weak var googleAdOutlet: GADBannerView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSearch3", sender: self)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func adsSetup() {
        googleAdOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAdOutlet.rootViewController = self
        googleAdOutlet.load(GADRequest())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSetup()
       // print(data!.venueName)
       // print(data!.volume)
        
        
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
