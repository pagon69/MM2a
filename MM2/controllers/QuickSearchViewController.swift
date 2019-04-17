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
            
            return heading
        }
        
        //Table view stuff
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var count = 0
            
            //default search view table
            if(tableView.tag == 0){
                count = searchResults?.count ?? 1
            }

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

            return cell
        }
        
        //select
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if(tableView.tag == 0){
                //print(searchResults?[indexPath.row].Symbol)
                currentIndexPath = indexPath.row
                performUserSearch(selectedValue: searchResults?[indexPath.row].Symbol ?? "Null")
                //svcProgressHUD would be good here
            }
            
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //this will cover the makers details
        if(segue.identifier == "goToDetails3"){
            let destVC: TableViewDetailsViewController = segue.destination as! TableViewDetailsViewController
           //print(userSelectedStockTwo.)
            // I have to update the following with the object i am sending
            destVC.data = userSelectedStockTwo
            //print("this is what i sent to the tableview detail controller: \(String(describing: searchResults?[currentIndexPath].Symbol))")
            }
        
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
        var userSelectedStock = [Stock]()
        var userSelectedStockTwo: Stock?
        
        //my functions
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            userInput = searchBar.text?.lowercased() ?? ""
            doSearch(searchV: userInput)
            searchBar.placeholder = "Enter stock"
            
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // take users data and do a search var userdata = searchBar.text"
        //call the data collection function
        performUserSearch(selectedValue: searchBar.text ?? "")
        print("did a search against: \(searchBar.text)")
    }
    
        func doSearch( searchV : String ){
            /*example of a array search
             searchR = myArray.filter({ (item) -> Bool in
             item.lowercased().contains(searchV)
             })
             */
            let items = myRealm.objects(Symbols.self).filter("Description CONTAINS[cd] %@", searchV).sorted(byKeyPath: "Description", ascending: true)
            
            //if(items.isEmpty){
                
           // }else{
                searchResults = items
          //  }
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
        
        
    func performUserSearch(selectedValue: String){
            //network request for data
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(selectedValue),&types=quote,news,financials,logo,earnings,chart&range=1m&last=5").responseJSON { (response) in
                
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
            //process the results
            print(json)
            for stocks in json{
                let myStocks = Stock()
    
                for each in stocks.1{
            
            //News processing
                    if(each.0 == "news"){
                        let myNews = News()
                        
                        for item in each.1{
                            
                            myNews.datetime = item.1["datetime"].stringValue
                            myNews.headline = item.1["headline"].stringValue
                            myNews.image = item.1["image"].stringValue
                            myNews.related = item.1["related"].stringValue
                            myNews.source = item.1["source"].stringValue
                            myNews.summary = item.1["summary"].stringValue
                            myNews.url = item.1["url"].stringValue
                            
                            myStocks.newsData.append(myNews)
                        }
                    }
            //charts processing
                    if(each.0 == "chart"){
                        
                        let myChart = Chart()
                        
                        for item in each.1{
                            myChart.close = item.1["close"].doubleValue
                            myChart.volume = item.1["volume"].stringValue
                            myChart.wvap = item.1["wvap"].stringValue
                            myChart.high = item.1["high"].stringValue
                            myChart.low = item.1["low"].doubleValue
                            myChart.open = item.1["open"].stringValue
                            myChart.date = item.1["date"].stringValue
                            myChart.changePercent = item.1["changepercent"].stringValue
                            myChart.unadjustedVolume = item.1["unadjustedVolume"].stringValue
                            myChart.changeOverTime = item.1["changeOverTime"].stringValue
                            myChart.label = item.1["label"].stringValue
                            
                            myStocks.chartsData.append(myChart)
                        }
                    }
            //logo processing
                    if(each.0 == "logo"){
                        myStocks.logo = each.1["url"].stringValue
                        print(myStocks.logo ?? "No logo available")
                    }
            //quote data processing
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
                //Financials processing
                    if(each.0 == "financials"){
                        
                        for item in each.1{
                            
                            for deeper in item.1{
                                
                                let myFinancial = Financials()
                                
                                myFinancial.cashChange = deeper.1["cashChange"].stringValue
                                myFinancial.cashFlow = deeper.1["cashChange"].stringValue
                                myFinancial.costOfRevenue = deeper.1["cashChange"].stringValue
                                myFinancial.currentAssets = deeper.1["cashChange"].stringValue
                                myFinancial.currentCash = deeper.1["cashChange"].stringValue
                                myFinancial.currentDebt = deeper.1["cashChange"].stringValue
                                myFinancial.grossProfit = deeper.1["cashChange"].stringValue
                                myFinancial.netIncome = deeper.1["cashChange"].stringValue
                                myFinancial.operatingexpense = deeper.1["cashChange"].stringValue
                                myFinancial.operatingGainsLosses = deeper.1["cashChange"].stringValue
                                myFinancial.operatingIncome = deeper.1["cashChange"].stringValue
                                myFinancial.operatingRevenue = deeper.1["cashChange"].stringValue
                                myFinancial.reportDate = deeper.1["cashChange"].stringValue
                                myFinancial.researchAndDevlopment = deeper.1["cashChange"].stringValue
                                myFinancial.shareholderEquity = deeper.1["cashChange"].stringValue
                                myFinancial.totalAssets = deeper.1["cashChange"].stringValue
                                myFinancial.totalDebt = deeper.1["cashChange"].stringValue
                                myFinancial.totalLiabilities = deeper.1["cashChange"].stringValue
                                myFinancial.totalRevenue = deeper.1["cashChange"].stringValue
                                myFinancial.cashChange = deeper.1["cashChange"].stringValue
                                
                                myStocks.financialData.append(myFinancial)
                            }
                        }
                    }
                    
                    //earnings processing
                    if(each.0 == "earnings"){
                        
                        for item in each.1{
                            
                            for deeper in item.1 {
                                
                                let myEarnings = Earnings()
                                
                                myEarnings.actualEPS = deeper.1["actualEPS"].doubleValue
                                myEarnings.announceTime = deeper.1["announceTime"].stringValue
                                myEarnings.consensusEPS = deeper.1["consensusEPS"].stringValue
                                myEarnings.EPSReportDate = deeper.1["EPSReportDate"].stringValue
                                myEarnings.EPSSurpriseDollar = deeper.1["EPSSurpriseDollar"].stringValue
                                myEarnings.estimatedChangePercent = deeper.1["estimatedChangePercent"].stringValue
                                myEarnings.estimatedEPS = deeper.1["estimatedEPS"].stringValue
                                myEarnings.FiscalEndDate = deeper.1["FiscalEndDate"].stringValue
                                myEarnings.fiscalPeriod = deeper.1["fiscalPeriod"].stringValue
                                myEarnings.numberOfEstimates = deeper.1["numberOfEstimates"].stringValue
                                myEarnings.symbolId = deeper.1["symbolId"].stringValue
                                myEarnings.yearAgo = deeper.1["yearAgo"].stringValue
                                myEarnings.yearAgoChangePercent = deeper.1["yearAgoChangePercent"].stringValue
                                
                                myStocks.earningsData.append(myEarnings)
                            }
                        }
                    }
                    
                    userSelectedStockTwo = myStocks
                    
                    //print(myStocks.companyName ?? "more testing")
                  //  print(myStocks.chartsData[0].high ?? "testing")
                    userSelectedStock.append(myStocks)
                   // marketStocks.append(myStocks)
                }
            }
                    
            performSegue(withIdentifier: "goToDetails3", sender: self)
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
            
            adsSetup()
            

            // Do any additional setup after loading the view.
        }
        
    }
    //end of class
