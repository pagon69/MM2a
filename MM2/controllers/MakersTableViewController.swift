//
//  MakersTableViewController.swift
//  MM2
//
//  Created by user147645 on 3/27/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import GoogleMobileAds


class MakersTableViewController: UIViewController{
   
    //globals
    var data: Markets?
    
    //user defaults
    let myDefaults = UserDefaults.standard
    var watchListItems = [String]()
    
    //outlets
    @IBOutlet weak var googleAdOutlet: GADBannerView!
    @IBOutlet weak var makerTextFieldOutlet: UITextView!
    
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSearch3", sender: self)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //add to watch list
    @IBAction func addToWatchList(_ sender: UIBarButtonItem) {
        
        //if the system can find a userwatchlist pull it and assign to userArray
        if let userArray = myDefaults.object(forKey: "userWatchList") as? [String]{
            let myUserValue = (data?.mic ?? "Null")
            if(userArray.contains(myUserValue)){
                //do nothing or maybe display an alret
            }else{
                watchListItems.append(contentsOf: userArray)
                watchListItems.append(myUserValue)
            }
            
        }else{ //did not find the userwatchlist,
            let myUserValue = (data?.mic ?? "Null")
            watchListItems.sort()
            if(watchListItems.contains(myUserValue)){
                
                //display an alert and dismiss it
            }else{
                //add to list
                watchListItems.append(myUserValue)
            }
        
        }
        
        myDefaults.set(watchListItems, forKey: "userWatchList")
        
        //can i do some animation ? or just an alert?
        
        print(watchListItems)
    }
    
    
    
    func adsSetup() {
        googleAdOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAdOutlet.rootViewController = self
        googleAdOutlet.load(GADRequest())
    }
    
    
    func setupSummary(){
        
        makerTextFieldOutlet.text = "Liquid Markets containing the stocks we love to gamble with:\nMarket name:\(data?.venueName ?? "No provided value")\nThe Mic: of symbol name is:\(String(describing: data?.mic ?? "null"))\nThe Volume is:\(String(describing: data?.volume ?? "null"))\nMarket share or percentage:\(String(describing: data?.marketPercent ?? "null"))"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSetup()
        setupSummary()
        
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
