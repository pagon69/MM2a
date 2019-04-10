//
//  WatchListViewController.swift
//  MM2
//
//  Created by user147645 on 4/10/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import GoogleMobileAds

class WatchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchListStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = watchListTableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(String(describing: watchListStocks[indexPath.row].companyName ?? "Null"))\n\(String(describing: watchListStocks[indexPath.row].symbol ?? "Null"))"
        cell.detailTextLabel?.text = "\(String(describing: watchListStocks[indexPath.row].latestPrice ?? "Null"))"
        
        return cell
    }
    
    
    //what should i add
    @IBAction func deleteWatchList(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    @IBAction func quickSearch(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    
    //outlets
    @IBOutlet weak var googleAds: GADBannerView!
    @IBOutlet weak var watchListTableView: UITableView!
    
    
    //globals
    let myDefaults = UserDefaults.standard
    var watchListItems = [String]()
    var formatedWatchList: String = ""
    var watchListStocks = [Stock]()
    
    //helper functions
    func viewSetup(){
        if let userArray = myDefaults.object(forKey: "userWatchList") as? [String]{
     
            watchListItems.append(contentsOf: userArray)
            
            for each in watchListItems{
                formatedWatchList = formatedWatchList + each + ","
            }
            
           // print("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10")
        }else {
            //no watch list items found
            
        }
     
    }
    
    
    // end of code cut
    
    func networkCall(){
        
        viewSetup()
        
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                self.processData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much data was sent: \(data)")
            }
        }
    }
    
    
    func processData(json: JSON){
        
            //process the results
        for stocks in json{
            let myStocks = Stock()
            
            for each in stocks.1{
                //charts
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
                
                //logo
                if(each.0 == "logo"){
                    myStocks.logo = each.1["url"].stringValue
                    print(myStocks.logo ?? "No logo available")
                }
                
                //quotes
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
            }
            
            watchListStocks.append(myStocks)
            
        }
    
    
        watchListTableView.reloadData()
    }
                          
    
    func adsSetup() {
        googleAds.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAds.rootViewController = self
        googleAds.load(GADRequest())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSetup()
        networkCall()
        
        // Do any additional setup after loading the view.
    }
    


}
