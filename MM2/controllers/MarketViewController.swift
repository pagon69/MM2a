//
//  MarketViewController.swift
//  MM2
//
//  Created by user147645 on 3/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class MarketViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    

    
    //UI search controller information, not using so remove?
        var testing = ["testing","tester","candy","daddy","mama"]
        let searchController = UISearchController(searchResultsController: nil)
    
    //not using this so remove?
        func updateSearchResults(for searchController: UISearchController) {
            //does search then puts it
            
            //var test = ["a", "b","c","d","e"]
            
    }
    
    //sections and table customization
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var heading: String = ""
        
        if(tableView.tag == 1){
            heading = "Major Indexes"
        }
        if(tableView.tag == 2){
            heading = "Exchanges"
            //tableView.sectionIndexBackgroundColor = .black
            //tableView.backgroundColor = .black
        }
        return heading
    }
    
    //Table view stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        //default search view table - i need to redo using search view controller
        if(tableView.tag == 0){
            count = searchResults?.count ?? 1
        }
 
        //Index table
        if(tableView.tag == 1){
            count = myArray.count
        }
        //Markets
        if(tableView.tag == 2){
            count = myMarkets.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        
        //Markets tableView cell
        if(tableView.tag == 1){
            cell = marketOutlet.dequeueReusableCell(withIdentifier: "marketsCell", for: indexPath)
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(myArray[indexPath.row])\n-34.56"
            
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "100.00\n📈-3.7%"
        }
        
        if(tableView.tag == 2){
            cell = makerOutlet.dequeueReusableCell(withIdentifier: "makersCell", for: indexPath)
        
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(myMarkets[indexPath.row].venueName)\n20000.23\n4.5%"
            
            cell.detailTextLabel?.text = "\n🔻"
            //my markets below
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //looks at markets tableView
        if(tableView.tag == 1){
            currentIndexPath = indexPath.row
            
            performSegue(withIdentifier: "goToMakersDetail", sender: self)
            
        }
        
        //looks at makers table View
        if(tableView.tag == 2){
            currentIndexPath = indexPath.row
            performSegue(withIdentifier: "goToTableViewDetail", sender: self)
            
        }
        
    }
    
    //prepares the environment for the multiple possible segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //this will cover the makers details
        if(segue.identifier == "goToMakersDetail"){
            let destVC: MakersTableViewController = segue.destination as! MakersTableViewController
            destVC.data = myMarkets[currentIndexPath]
        }
        
        
        //this will cover the markets
        if(segue.identifier == "goToTableViewDetail"){
            
            let destVC: TableViewDetailsViewController = segue.destination as! TableViewDetailsViewController
            destVC.data = myMarkets[currentIndexPath]
        }
        
    }
    
    
    
    //outlets and IB stuff
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    //new outlets for coding
    @IBOutlet weak var marketOutlet: UITableView!
    @IBOutlet weak var makerOutlet: UITableView!
    

    //search button segue
    @IBAction func searchButtonOutlet(_ sender: UIBarButtonItem) {
    
        performSegue(withIdentifier: "goToSearch", sender: self)

    }
    
    //back button
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
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
    var marketStocks: [Stock] = [Stock]()
    
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
        
        
        //network request for liquid markets
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
        
        //network request for Major indexices
        //need to figure out this part and where to get the indices
        Alamofire.request("https://api.iextrading.com/1.0/stock/aapl/batch?types=quote,financials,earnings,news,chart&range=1m&last=10").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                self.processData2(json: myJson)
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
        marketOutlet.reloadData()
        makerOutlet.reloadData()
    }
    
    //processes data for the second table
    func processData2(json: JSON){
        
        let myStocks = Stock()
        
      //process the results
        for each in json{
                //check the dictionary and process results
            if(each.0 == "news"){
                print("in news")
            }
            if(each.0 == "chart"){
                
                let myChart = Chart()
                
                for item in each.1{
                    myChart.close = item.1["close"].stringValue
                    
                   // print(myChart.close)
                    myStocks.chartsData.append(myChart)
                   // print("items inmystocks within charts: \(myStocks.chartsData.count)")
                }
                
                
              //  myStocks.chartsData.append(myChart)
                
            }
            if(each.0 == "quote"){
               
                myStocks.symbol = each.1["symbol"].stringValue
                myStocks.companyName = each.1["companyName"].stringValue
                myStocks.primaryExchange = each.1["primaryExchange"].stringValue
                myStocks.sector = each.1["sector"].stringValue
                myStocks.calculationPrice = each.1["calculationPrice"].stringValue
                myStocks.open = each.1["open"].stringValue
                myStocks.openTime = each.1["openTime"].stringValue
                myStocks.close = each.1["close"].stringValue
                myStocks.closeTime = each.1["closeTime"].stringValue
                myStocks.high = each.1["high"].stringValue
                myStocks.low = each.1["low"].stringValue
                myStocks.latestPrice = each.1["latestPrice"].stringValue
                myStocks.latestSource = each.1["latestSource"].stringValue
                myStocks.latestTime = each.1["latestTime"].stringValue
                myStocks.latestUpdate = each.1["latestUpdate"].stringValue
                myStocks.latestVolume = each.1["latestVolume"].stringValue
                myStocks.iexRealTimePrice = each.1["iexRealTimePrice"].stringValue
                myStocks.ieRealtimeSize = each.1["ieRealtimeSize"].stringValue
                myStocks.iexLastUpdated = each.1["iexLastUpdated"].stringValue
                myStocks.delayedPrice = each.1["delayedPrice"].stringValue
                myStocks.delayedPriceTime = each.1["delayedPriceTime"].stringValue
                myStocks.extendedPrice = each.1["extendedPrice"].stringValue
                myStocks.extendedChange = each.1["extendedChange"].stringValue
                myStocks.extendedChangePercent = each.1["extendedChangePercent"].stringValue
                myStocks.extendedPriceTime = each.1["extendedPriceTime"].stringValue
                myStocks.previousClose = each.1["previousClose"].stringValue
                myStocks.change = each.1["change"].stringValue
                myStocks.changePercent = each.1["changePercent"].stringValue
                myStocks.iexMarketPercent = each.1["iexMarketPercent"].stringValue
                myStocks.iexVolume = each.1["iexVolume"].stringValue
                myStocks.avgTotalVolume = each.1["avgTotalVolume"].stringValue
                myStocks.iexBidPrice = each.1["iexBidPrice"].stringValue
                myStocks.iexBidSize = each.1["iexBidSize"].stringValue
                myStocks.iexAskPrice = each.1["iexAskPrice"].stringValue
                myStocks.iexAskSize = each.1["iexAskSize"].stringValue
                myStocks.marketCap = each.1["marketCap"].stringValue
                myStocks.peRation = each.1["peRation"].stringValue
                myStocks.week52High = each.1["week52High"].stringValue
                myStocks.week52Low = each.1["week52Low"].stringValue
                myStocks.ytdChange = each.1["ytdChange"].stringValue

            }
            if(each.0 == "financials"){
                print("in financials")
            }
            if(each.0 == "earnings"){
                print("in earnings")
            }
            
            
            marketStocks.append(myStocks)
            //print("in market stocs: \(marketStocks.count)")
           // print(" in the stock: \(myStocks.chartsData.count)")
        }
        
        print(marketStocks[3].chartsData[0].high)
        
    
        
        marketOutlet.reloadData()
        makerOutlet.reloadData()
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
