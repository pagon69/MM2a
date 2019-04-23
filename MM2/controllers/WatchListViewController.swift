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

class WatchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    
    
    //table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchListStocks.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = watchListTableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(String(describing: watchListStocks[indexPath.row].companyName ?? "Search for and Add stocks  to you WatchList!! "))\n\(String(describing: watchListStocks[indexPath.row].symbol ?? ""))"
        cell.detailTextLabel?.text = "\(String(describing: watchListStocks[indexPath.row].latestPrice ?? ""))"
        
        return cell
    }
    
    //delete cell from watchlist
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    }
    
    //what should i add
    @IBAction func deleteWatchList(_ sender: UIBarButtonItem) {
        
        watchListStocks.removeAll()
        watchListTableView.reloadData()
    
        myDefaults.set(watchListStocks, forKey: "userWatchList")
        
    }
    
    /*attempting to say when you get clicked run view setup function
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewSetup()
        print("in tab bar delegate")
    }
    */

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            currentIndexPath = indexPath.row
            performSegue(withIdentifier: "goToTableView2", sender: self)
    }
    
    
    @IBAction func quickSearch(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToSearch6", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //this will cover the makers details
        if(segue.identifier == "goToTableView2"){
            let destVC: TableViewDetailsViewController = segue.destination as! TableViewDetailsViewController
            destVC.data = watchListStocks[currentIndexPath]
            
        }
        
    }
    
    //outlets
    @IBOutlet weak var googleAds: GADBannerView!
    @IBOutlet weak var watchListTableView: UITableView!
    @IBOutlet weak var tickerBanner: UIView!
    
    @IBOutlet weak var ticker1: UIView!
    @IBOutlet weak var t1Name: UILabel!
    @IBOutlet weak var t1Picture: UILabel!
    @IBOutlet weak var t1Price: UILabel!
    @IBOutlet weak var t1Change: UILabel!
    
    @IBOutlet weak var ticker2: UIView!
    @IBOutlet weak var t2Name: UILabel!
    @IBOutlet weak var t2Picture: UILabel!
    @IBOutlet weak var t2Price: UILabel!
    @IBOutlet weak var t2Change: UILabel!
    
    @IBOutlet weak var ticker3: UIView!
    @IBOutlet weak var t3Name: UILabel!
    @IBOutlet weak var t3Picture: UILabel!
    @IBOutlet weak var t3Price: UILabel!
    @IBOutlet weak var t3Change: UILabel!
    
    @IBOutlet weak var ticker4: UIView!
    @IBOutlet weak var t4Name: UILabel!
    @IBOutlet weak var t4Picture: UILabel!
    @IBOutlet weak var t4Price: UILabel!
    @IBOutlet weak var t4Change: UILabel!
    
    @IBOutlet weak var ticker5: UIView!
    @IBOutlet weak var t5Name: UILabel!
    @IBOutlet weak var t5Picture: UILabel!
    @IBOutlet weak var t5Price: UILabel!
    @IBOutlet weak var t5Change: UILabel!
    
    @IBOutlet weak var ticker6: UIView!
    @IBOutlet weak var t6Name: UILabel!
    @IBOutlet weak var t6Picture: UILabel!
    @IBOutlet weak var t6Price: UILabel!
    @IBOutlet weak var t6Change: UILabel!
    
    //globals
    let myDefaults = UserDefaults.standard
    var watchListItems = [String]()
    var formatedWatchList: String = ""
    var watchListStocks = [Stock]()
    var currentIndexPath = 0
    let keyMarketStock = ["dia","spy", "fb", "aapl", "goog", "good"]
    var myTickers = [Ticker]()
    var mySortedTickers = [Ticker]()
    var myTimer = Timer()
    var lastTicker = CGFloat()
    var timing = 0
    
    //ticker functions can i make this better?
    
    func startAnimating(){
        timing += 1
        ticker1.center.x = ticker1.center.x  - 10
        ticker2.center.x = ticker2.center.x  - 10
        ticker3.center.x = ticker3.center.x  - 10
        ticker4.center.x = ticker4.center.x  - 10
        ticker5.center.x = ticker5.center.x  - 10
        ticker6.center.x = ticker6.center.x  - 10
        
        if(ticker1.center.x + ticker1.frame.width/2 < 0){
            //replace print statement with api call
            //  print("download new info and setup")
            ticker1.center.x = ticker6.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 1)
        }
        
        if(ticker2.center.x + ticker2.frame.width/2 < 0){
            //print("download a stock for ticker 2 and update ticker settings")
            ticker2.center.x = ticker1.center.x + ticker1.frame.width + 10
            //view.center.x + view.center.x/2
            refreashTicker(currentTicker: 2)
        }
        
        if(ticker3.center.x + ticker3.frame.width/2 < 0){
            //print("download a stock for ticker 3 and update ticker settings")
            ticker3.center.x = ticker2.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 3)
        }
    
        if(ticker4.center.x + ticker3.frame.width/2 < 0){
            ticker4.center.x = ticker3.center.x + ticker1.frame.width + 10
            //print("download a stock for ticker 4 and update ticker settings")
            refreashTicker(currentTicker: 4)
            
        }
        
        if(ticker5.center.x + ticker4.frame.width/2 < 0){
            ticker5.center.x = ticker4.center.x + ticker1.frame.width + 10
            //print("download a stock for ticker 5 and update ticker settings")
            refreashTicker(currentTicker: 5)
            
        }
        
        if(ticker6.center.x + ticker5.frame.width/2 < 0){
            ticker6.center.x = ticker5.center.x + ticker1.frame.width + 10
            //print("download a stock for ticker 6 and update ticker settings")
            refreashTicker(currentTicker: 6)
            
        }
        
    }
    
    func startPosition(){
        
        randomTickerValues()
        
        let startingPos = view.frame.maxX + ticker1.frame.width/2
        let tickersize = ticker1.frame.width + 10
        
        //starting position off screen, should adjust to various screen sizes
        ticker1.center.x = startingPos
        
        ticker2.center.x = startingPos + tickersize
        
        ticker3.center.x = startingPos + 2 * tickersize
        
        ticker4.center.x = startingPos + 3 * tickersize
        
        ticker5.center.x = startingPos + 4 * tickersize
        
        ticker6.center.x = startingPos + 5 * tickersize
        
        lastTicker = startingPos + 5 * tickersize
    }
    
    func refreashTicker(currentTicker: Int){
        //do for just one right now
        if(currentTicker == 1){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
                    //print(myJson)
                    self.t1Name.text = myJson["symbol"].stringValue
                    self.t1Price.text = myJson["high"].stringValue
                    self.t1Change.text = myJson["changePercent"].stringValue
                    
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
        }
        if(currentTicker == 2){
            
        }
    }
    
    func randomTickerValues(){
        var combined = ""
        for each in keyMarketStock{
            combined = combined + "," + each
        }
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=" + combined + "&types=quote").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                for each in myJson{
                    let tickerValue = Ticker(name: each.1["quote"]["symbol"].stringValue, price: each.1["quote"]["high"].stringValue, change: each.1["quote"]["changePercent"].stringValue, picture : "🔥")
                    self.myTickers.append(tickerValue)
                    // print("this is whats in ticker now: \(self.myTickers)")
                }
                
                self.startingValue()
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("How much data was sent: \(data)")
            }
        }
        
        //print("this is whats in ticker now: \(self.myTickers)")
    }
    
    func startingValue(){
        print("in starting value")
        var i = 0
        while i <= myTickers.count {
            if(i == 0){
                t1Name.text = myTickers[i].name
                t1Price.text = myTickers[i].price
                t1Change.text = myTickers[i].change
            }
            if(i == 1){
                t2Name.text = myTickers[i].name
                t2Price.text = myTickers[i].price
                t2Change.text = myTickers[i].change
            }
            if(i == 2){
                t3Name.text = myTickers[i].name
                t3Change.text = myTickers[i].change
                t3Price.text = myTickers[i].price
            }
            if(i == 3){
                t4Name.text = myTickers[i].name
                t4Change.text = myTickers[i].change
                t4Price.text = myTickers[i].price
            }
            if(i == 4){
                t5Name.text = myTickers[i].name
                t5Change.text = myTickers[i].change
                t5Price.text = myTickers[i].price
            }
            if(i == 5){
                t6Name.text = myTickers[i].name
                t6Change.text = myTickers[i].change
                t6Price.text = myTickers[i].price
            }
            i += 1
        }
    }
    
            
            
            
            
    
    
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
     
        watchListTableView.reloadData()
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
        
        startPosition()
        
        myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.startAnimating()
        })
        
        // Do any additional setup after loading the view.
    }
    


}
