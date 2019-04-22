//
//  DeepDiveViewController.swift
//  MM2
//
//  Created by user147645 on 4/16/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
import AlamofireImage
import SwiftyJSON



class DeepDiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //globals
    var winners = [Stock]()
    var losers = [Stock]()
    var IPOs = [IPO]()
    var currentIndex = 0
    
    //below is needed for ticker
    let keyMarketStock = ["dia","spy", "fb", "aapl", "goog", "good"]
    var myTickers = [Ticker]()
    var mySortedTickers = [Ticker]()
    var myTimer = Timer()
    var lastTicker = CGFloat()
    var timing = 0
    
    //Outlets
    @IBOutlet weak var tickerbanner: UIView!
    @IBOutlet weak var ticker1: UIView!
    @IBOutlet weak var ticker2: UIView!
    @IBOutlet weak var ticker3: UIView!
    @IBOutlet weak var ticker4: UIView!
    @IBOutlet weak var ticker5: UIView!
    @IBOutlet weak var ticker6: UIView!
    
    @IBOutlet weak var t1: UIView!
    @IBOutlet weak var t1Name: UILabel!
    @IBOutlet weak var t1Picture: UILabel!
    @IBOutlet weak var t1Price: UILabel!
    @IBOutlet weak var t1Change: UILabel!
    
    @IBOutlet weak var t2: UIView!
    @IBOutlet weak var t2Name: UILabel!
    @IBOutlet weak var t2Picture: UILabel!
    @IBOutlet weak var t2Price: UILabel!
    @IBOutlet weak var t2Change: UILabel!
    
    @IBOutlet weak var t3: UIView!
    @IBOutlet weak var t3Name: UILabel!
    @IBOutlet weak var t3Picture: UILabel!
    @IBOutlet weak var t3Price: UILabel!
    @IBOutlet weak var t3Change: UILabel!
    
    @IBOutlet weak var t4: UIView!
    @IBOutlet weak var t4Name: UILabel!
    @IBOutlet weak var t4Picture: UILabel!
    @IBOutlet weak var t4Price: UILabel!
    @IBOutlet weak var t4Change: UILabel!
    
    @IBOutlet weak var t5: UIView!
    @IBOutlet weak var t5Name: UILabel!
    @IBOutlet weak var t5Picture: UILabel!
    @IBOutlet weak var t5Price: UILabel!
    @IBOutlet weak var t5Change: UILabel!
    
    @IBOutlet weak var t6: UIView!
    @IBOutlet weak var t6Name: UILabel!
    @IBOutlet weak var t6Picture: UILabel!
    @IBOutlet weak var t6Price: UILabel!
    @IBOutlet weak var t6Change: UILabel!
    
    
    
    func startAnimating(){
        timing += 1
        t1.center.x = t1.center.x  - 10
        t2.center.x = t2.center.x  - 10
        t3.center.x = t3.center.x  - 10
        t4.center.x = t4.center.x  - 10
        t5.center.x = t5.center.x  - 10
        t6.center.x = t6.center.x  - 10
    
        if(t1.center.x + t1.frame.width/2 < 0){
            //replace print statement with api call
            //  print("download new info and setup")
            t1.center.x = t6.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 1)
        }
        
        if(t2.center.x + t2.frame.width/2 < 0){
            //print("download a stock for ticker 2 and update ticker settings")
            t2.center.x = t1.center.x + t1.frame.width + 10
            //view.center.x + view.center.x/2
            refreashTicker(currentTicker: 2)
        }
        
        if(t3.center.x + t3.frame.width/2 < 0){
            //print("download a stock for ticker 3 and update ticker settings")
            t3.center.x = t2.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 3)
        }
        
        if(t4.center.x + t3.frame.width/2 < 0){
            t4.center.x = t3.center.x + t1.frame.width + 10
            //print("download a stock for ticker 4 and update ticker settings")
            refreashTicker(currentTicker: 4)
            
        }
        
        if(t5.center.x + t4.frame.width/2 < 0){
            t5.center.x = t4.center.x + t1.frame.width + 10
            //print("download a stock for ticker 5 and update ticker settings")
            refreashTicker(currentTicker: 5)
            
        }
        
        if(t6.center.x + t5.frame.width/2 < 0){
            t6.center.x = t5.center.x + t1.frame.width + 10
            //print("download a stock for ticker 6 and update ticker settings")
            refreashTicker(currentTicker: 6)
            
        }
        
    }
    
    func startPosition(){
        
        randomTickerValues()
        
        let startingPos = view.frame.maxX + t1.frame.width/2
        let tickersize = t1.frame.width + 10
        
        //starting position off screen, should adjust to various screen sizes
        t1.center.x = startingPos
        
        t2.center.x = startingPos + tickersize
        
        t3.center.x = startingPos + 2 * tickersize
        
        t4.center.x = startingPos + 3 * tickersize
        
        t5.center.x = startingPos + 4 * tickersize
        
        t6.center.x = startingPos + 5 * tickersize
        
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
    
    //tableview information
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        //ipos table
        if(tableView.tag == 1){
           // count = IPOs.count
            count = 1
        }
        //movers table
        if(tableView.tag == 2){
            //count = winners.count
            count = 1
        }
        //losers table
        if(tableView.tag == 3){
            //count = losers.count
            count = 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        //ipos
        if(tableView.tag == 1){
            cell = ipoTableView.dequeueReusableCell(withIdentifier: "ipoCell", for: indexPath)
            
            if(IPOs.count == 0){
                cell.textLabel?.text = "No IPOs available at this time, Try again after the Market opens"
            }else
            {
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "\(String(describing: IPOs[indexPath.row].companyName))\n\(String(describing: IPOs[indexPath.row].symbol))"
            
                cell.detailTextLabel?.text = "$\(String(describing: IPOs[indexPath.row].priceLow)) -   $\(String(describing: IPOs[indexPath.row].priceHigh))"
            }
        }
        
        //movers
        if(tableView.tag == 2){
            cell = moversAndShakersTableView.dequeueReusableCell(withIdentifier: "moversAndShakerCell", for: indexPath)
            
            cell.textLabel?.text = "APPle Inc"
            cell.detailTextLabel?.text = "price goes here"
            
        }
        
        //losers
        if(tableView.tag == 3){
            cell = losersTableView.dequeueReusableCell(withIdentifier: "losersCell", for: indexPath)
            
            cell.textLabel?.text = "Google Inc"
            cell.detailTextLabel?.text = "price goes here"
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        
    }
    
    func collectMarketData(){
        
        //ipos window - need to check both upcoming and todays then display which ever has more data
        //https://api.iextrading.com/1.0/stock/market/upcoming-ipos
        //https://api.iextrading.com/1.0/stock/market/today-ipos
        //(myJson["viewData"].isEmpty || myJson["rawData"].isEmpty)
        
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/upcoming-ipos").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                self.processIPOData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
        
        //todays
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/today-ipos").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                self.processIPOData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
        
        
        //movers and shakers data call
        //https://api.iextrading.com/1.0/stock/market/list/mostactive
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/list/mostactive").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                self.processMoversData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
        
        //losers data call
        //https://api.iextrading.com/1.0/stock/market/list/losers
        
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/list/losers").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                self.processLosersData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
        
    }
    
    func processIPOData(json : JSON){
        //json["viewData"].isEmpty && json["rawData"].isEmpty

        for each in json{
            for ipos in each.0{
                



            }
        }
        
        //end of data processing
    }
    
    func processMoversData(json : JSON){
        //print(json)
        
        
        
        
    }
    
    func processLosersData(json : JSON){
        
    }
    
    //outlets
    @IBOutlet weak var googleAds: GADBannerView!
    @IBOutlet weak var ipoTableView: UITableView!
    @IBOutlet weak var moversAndShakersTableView: UITableView!
    @IBOutlet weak var losersTableView: UITableView!
    
    
    @IBAction func Disclaimers(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToDisclaimers", sender: self)
        
    }
    
    
    
    func adsSetup() {
        googleAds.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAds.rootViewController = self
        googleAds.load(GADRequest())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        adsSetup()
        collectMarketData()
        startPosition()
        
        myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.startAnimating()
        })
        
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
