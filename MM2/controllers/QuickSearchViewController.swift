//
//  QuickSearchViewController.swift
//  MM2
//
//  Created by user147645 on 3/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class QuickSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{

    //begining of code

        //sections and table customization
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            var heading: String = ""
            
            if(tableView.tag == 0){
                heading = "Known Stocks/Symbols as 01/28/2019"
            }
            
            /*
            if(tableView.tag == 1){
                heading = "USA Markets by Percentage"
            }
            if(tableView.tag == 2){
                heading = "Market Makers"
                //tableView.sectionIndexBackgroundColor = .black
                //tableView.backgroundColor = .black
            }
            */
            
            return heading
        }
        
        //Table view stuff
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var count = 0
            
            //default search view table
            if(tableView.tag == 0){
                count = searchResults?.count ?? 1
            }
            
            /*markets table
            if(tableView.tag == 1){
                count = myMarkets.count
            }
            //Makers table
            if(tableView.tag == 2){
                count = myArray.count
            }
            */
            return count
        }
    
    
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = UITableViewCell()
   
            //search table view cell
            if(tableView.tag == 0){
                
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                cell.textLabel?.text = searchResults?[indexPath.row].Description
                cell.detailTextLabel?.text = searchResults?[indexPath.row].Symbol
                
            }
            
            
            /*Markets tableView cell
            if(tableView.tag == 1){
                cell = marketOutlet.dequeueReusableCell(withIdentifier: "marketsCell", for: indexPath)
                print(myMarkets[indexPath.row].venueName)
                
                cell.textLabel?.text = "\(myMarkets[indexPath.row].venueName)\nVol:\(myMarkets[indexPath.row].volume)\nMarket %:\(myMarkets[indexPath.row].marketPercent)"
            }
            //Makers tableview cell
            if(tableView.tag == 2){
                cell = makerOutlet.dequeueReusableCell(withIdentifier: "makersCell", for: indexPath)
                cell.textLabel?.text = myArray[indexPath.row]
                cell.detailTextLabel?.text = "something for me to display"
            }
             */
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if(tableView.tag == 0){
                //print(searchResults?[indexPath.row].Symbol)
                currentIndexPath = indexPath.row
            }
            
            /*looks at markets tableView
            if(tableView.tag == 1){
                print("the selected row is :\(indexPath.row)")
                print("the contained data is:\(myMarkets[indexPath.row].venueName)")
                
            }
            
            //looks at makers table View
            if(tableView.tag == 2){
                print("the selected row is :\(indexPath.row)")
                print("the contained data is:\(myArray[indexPath.row])")
                
            }
            */
        }
    
        
        //search button segue
        @IBAction func searchButtonOutlet(_ sender: UIBarButtonItem){
            
            performSegue(withIdentifier: "goToSearch", sender: self)
            
        }
        
        //back button
        @IBAction func backButton(_ sender: UIBarButtonItem) {
            self.dismiss(animated: true, completion: nil)
        }
        
        //outlets
        @IBOutlet weak var googleAdsOutlet: GADBannerView!
        
        //my global variables
        let myArray = ["car","boat","house","mace","gun","door","banana"]
        var searchResults :Results<Symbols>?
        var timing = 0
        var myTimer = Timer()
        
        var myRealm = try! Realm()
        
        var lastTicker = CGFloat()
        var currentIndexPath = 0
        var userInput = ""
        var searchR = [String]()
        var myMarkets :[Markets] = [Markets]()
        var data : Markets?
        
        //my functions
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            userInput = searchBar.text?.lowercased() ?? ""
            doSearch(searchV: userInput)
            searchBar.placeholder = "Enter stock"
            
        }
        
        func doSearch( searchV : String ){
            /*example of a array search
             searchR = myArray.filter({ (item) -> Bool in
             item.lowercased().contains(searchV)
             })
             */
            let items = myRealm.objects(Symbols.self).filter("Description CONTAINS[cd] %@", searchV).sorted(byKeyPath: "Description", ascending: true)
            
            searchResults = items
        }
        
        //opens the default realm then i change the path and replace with my bundle
        func openRealm() {
            let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
            let bundleRealmPath = Bundle.main.url(forResource: "symbols", withExtension: "realm")
            
            if FileManager.default.fileExists(atPath: defaultRealmPath.absoluteString) {
                do{
                    try FileManager.default.removeItem(at: defaultRealmPath)
                    print("deleted the default realm")
                }catch {
                    print("could not delete the default realm")
                }
                do {
                    try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
                    print("coping the files")
                }catch let error {
                    print("error copying seed files: \(error)")
                }
            }
        }
        
        
        func collectMarketData(){
            //network request for data
            Alamofire.request("https://api.iextrading.com/1.0/market").responseJSON { (response) in
                if let json = response.result.value {
                    let myJson = JSON(json)
                    self.processData(json: myJson)
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("Got data, this much was sent: \(data)")
                }
            }
            
        }
        
        //processes data for the market page
        func processData(json: JSON){
            
            for each in json{
                
                //need to create a market object with all of the data
                let market = Markets(mic: each.1["mic"].stringValue, tapeId: each.1["tapeId"].stringValue, venueName: each.1["venueName"].stringValue, volume: each.1["marketPercent"].stringValue, marketPercent: each.1["volume"].stringValue, charts: [1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5], tapeA: each.1["tapeA"].stringValue, tapeB: each.1["tabeB"].stringValue, tapeC: each.1["tapeC"].stringValue, lastUpdated: each.1["lastUpdated"].stringValue)
                
                myMarkets.append(market)
            }
           // marketOutlet.reloadData()
        }
        
        func adsSetup() {
            googleAdsOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
            googleAdsOutlet.rootViewController = self
            googleAdsOutlet.load(GADRequest())
        }
        
        // start of all runtime stuff
        override func viewDidLoad() {
            super.viewDidLoad()
            
            openRealm()
            
            //realm configuration stuff
            let bundleRealmPath = Bundle.main.url(forResource: "symbols", withExtension: "realm")
            let config = Realm.Configuration(fileURL: bundleRealmPath,
                                             readOnly: true,
                                             schemaVersion: 0,
                                             migrationBlock:
                { migration, oldSchemaVersion in
                    if(oldSchemaVersion < 1){
                        print("do nothing")
                    }
            })
            
            //  let realm = try! Realm(configuration: config)
            myRealm = try! Realm(configuration: config)
            
            collectMarketData()
            
            adsSetup()
            

            // Do any additional setup after loading the view.
        }
        
    }
    //end of class
