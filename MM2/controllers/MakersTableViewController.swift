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
    var timingCount = 0
    var myTimer = Timer()
    
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
                displayAlert(alertMessage: "\(data?.mic ?? "Null") is already on the WatchList", resultsMessage: "🛑")
            }else{
                watchListItems.append(contentsOf: userArray)
                watchListItems.append(myUserValue)
                displayAlert(alertMessage: "Adding \(data?.mic ?? "Null") to WatchList.", resultsMessage: "✅")
                watchListItems.sort()
                myDefaults.set(watchListItems, forKey: "userWatchList")
                print("myDefaults found, newly added value not within array so adding it.")
            }
        }else{ //did not find the userwatchlist,
            let myUserValue = (data?.mic ?? "Null")
            //watchListItems.sort()
            if(watchListItems.contains(myUserValue)){
                displayAlert(alertMessage: "\(data?.mic ?? "Null") is currently in the WatchList", resultsMessage: "🛑")
            }else{
                //add to list
                watchListItems.append(myUserValue)
                displayAlert(alertMessage: "Adding \(data?.mic ?? "Null") to your WatchList.", resultsMessage: "✅")
                myDefaults.set(watchListItems, forKey: "userWatchList")
                print("the watchlist didnt exist in my defaults and the stock wasnt in there")
            }
        }
        
        print("this is what should be saved in the watchlist: \(watchListItems)")
    }
    
    
    func displayAlert(alertMessage: String, resultsMessage: String){

        let myAlert = UIAlertController(title: alertMessage, message: resultsMessage, preferredStyle: .alert)
        
        present(myAlert, animated: true) {
            
            //displays an alert which disappears after 2 seconds
             self.myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.timingCount = self.timingCount + 1
                if(self.timingCount >= 2){
                    self.myTimer.invalidate()
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
        
    }
    
    
    
    func adsSetup() {
        googleAdOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAdOutlet.rootViewController = self
        googleAdOutlet.load(GADRequest())
    }
    
    
    func setupSummary(){
       
        /* attempting to format the data precented
        var test2: NSMutableAttributedString = NSMutableAttributedString(string: "testering string")

        if let venueName =  data?.venueName{
            
            let test = NSMutableAttributedString(string: venueName)
            //add in the code to convert or change font title, size or color.
           // test.addAttribute(.font, value: 16, range: NSMakeRange(5, 4))
           // test.addAttribute(.backgroundColor, value: <#T##Any#>, range: <#T##NSRange#>)
           // test2 = test
        }
        */
        
        makerTextFieldOutlet.text = "\n\nMarket name: \(data?.venueName ?? " --- ")\nThe Mic: \(String(describing: data?.mic ?? "null"))\nThe Volume is: \(String(describing: data?.volume ?? "null"))\nMarket percentage %: \(String(describing: data?.marketPercent ?? "null"))\nTapeA shares: \(String(describing: data?.tapeA ?? "null"))\nTapeB Shares: \(String(describing: data?.tapeB ?? "0"))\nTapeC shares: \(String(describing: data?.tapeC ?? "null"))\nData Updated: \(String(describing: data?.lastUpdated ?? "null"))\n\n\n\n\nDiffinitions:\nLiquidity Markets: A market in which there are large quantities of trades. The advantage of a Liquid Market is that investments can be easily transferred into cash as a good rate in a timely fashion.\n\nMIC = Market Identifier Code, or symbol\n\nTapeID = tape id of the venue\n\nVolume = refers to the total amount of traded shares reported for the day.\n\n Tape A, Tape B, Tape C - refers to the amount of traded shares of type A,B, or C shares."
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSetup()
        setupSummary()
        
        // Do any additional setup after loading the view.
    }

}
