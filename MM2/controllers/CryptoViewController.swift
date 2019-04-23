//
//  CryptoViewController.swift
//  MM2
//
//  Created by user147645 on 3/27/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import GoogleMobileAds
import SVProgressHUD

class CryptoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //table view setup
    // attempting to edit this
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cryptoTableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath)
        
        /* customize
        cell.contentView.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: 365, height: 44))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: .init(iccData: CFTypeRef.self as CFTypeRef), components: [1.0,1.0,1.0,0.8])
        whiteRoundedView.translatesAutoresizingMaskIntoConstraints = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: -1)
        whiteRoundedView.layer.shadowOpacity = 2.0
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        */
        
        
        
        
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor.yellow
        
        cell.textLabel?.text = "\(String(describing: myStocksArray[indexPath.section].companyName ?? "Null"))\n\(String(describing: myStocksArray[indexPath.section].symbol ?? "Null"))"
        cell.detailTextLabel?.text = myStocksArray[indexPath.section].latestPrice ?? "Null"
        
        return cell
    }
 
    //customize code - adds spaces between cells
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return myStocksArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return myStocksArray.count
        return 1
    }
    
    //customize code ends
    
    //add the selection of a row code here
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            currentIndexPath = indexPath.row
            performSegue(withIdentifier: "cryptoSegue", sender: self)
    }
    
    
    
    
    
    //segues to data process and view page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //this will cover the makers details
        if(segue.identifier == "cryptoSegue"){
            let destVC: TableViewDetailsViewController = segue.destination as! TableViewDetailsViewController
            destVC.data = myStocksArray[currentIndexPath]
        }

    }
    
    //add segue to cryptoSegue here


    
    
    //outlets
    @IBOutlet weak var googleAdsOutlet: GADBannerView!
    @IBOutlet weak var cryptoTableView: UITableView!
    
    //ticker outlets
    @IBOutlet weak var tickerBanner: UIView!
    
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
    
    
    @IBAction func goToSearch(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToSearch8", sender: self)    }
    
    
    //globals
    var myStocksArray = [Stock]()
    var currentIndexPath = 0
    
    var publicKey = "pk_77b4f9e303f64472a2a520800130d684"
    let keyMarketStock = ["dia","spy", "fb", "aapl", "goog", "good"]
    var myTickers = [Ticker]()
    var mySortedTickers = [Ticker]()
    var myTimer = Timer()
    var lastTicker = CGFloat()
    var timing = 0
    
    //ticker functions
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
    
    
    
    
    
    
    func networkCall(){
        
        SVProgressHUD.show()
       // let newMethod = "https://cloud.iexapis.com/stable/stock/aapl/advanced-stats/token=\(publicKey)"
        let oldMethod = "https://api.iextrading.com/1.0/stock/market/crypto"
        
        Alamofire.request(oldMethod).responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                print(myJson)
                
                self.processData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
    }
    
    func processData(json: JSON){
        
        for each in json{
            
            let myStocks = Stock()
            
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
            
            myStocksArray.append(myStocks)
            }
        
            SVProgressHUD.dismiss()
            cryptoTableView.reloadData()
        
        }
    
    
    
    func adsSetup() {
        googleAdsOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAdsOutlet.rootViewController = self
        googleAdsOutlet.load(GADRequest())
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
