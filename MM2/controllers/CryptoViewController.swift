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

class CryptoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //table view setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStocksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cryptoTableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(String(describing: myStocksArray[indexPath.row].companyName ?? "Null"))\n\(String(describing: myStocksArray[indexPath.row].symbol ?? "Null"))"
        cell.detailTextLabel?.text = myStocksArray[indexPath.row].latestPrice ?? "Null"
        
        return cell
    }
    

    
    //outlets
    @IBOutlet weak var googleAdsOutlet: GADBannerView!
    @IBOutlet weak var cryptoTableView: UITableView!
    
    
    //globals
    var myStocksArray = [Stock]()
    
    
    func networkCall(){
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/crypto").responseJSON { (response) in
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
