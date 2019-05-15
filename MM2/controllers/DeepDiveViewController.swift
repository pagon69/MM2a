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
import SVProgressHUD



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
    var currentPicture = ""
    
    enum pictures: String {
        case up = "💹"
        case down = "🔻"
        case stable = "⎯"
        case onFire = "🔥"
        case cold = "❄️"
    }
    
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
    
    
    @IBAction func quickSearchButton(_ sender: UIBarButtonItem) {
        
         performSegue(withIdentifier: "deepToQuickSearch", sender: self)
        
    }
    
    
    
    
    func startAnimating(){
        timing += 1
        t1.center.x = t1.center.x  - 10
        t2.center.x = t2.center.x  - 10
        t3.center.x = t3.center.x  - 10
        t4.center.x = t4.center.x  - 10
        t5.center.x = t5.center.x  - 10
        t6.center.x = t6.center.x  - 10
    
        if(t1.center.x + t1.frame.width/2 < 0){
            t1.center.x = t6.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 1)
        }
        
        if(t2.center.x + t2.frame.width/2 < 0){
            t2.center.x = t1.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 2)
        }
        
        if(t3.center.x + t3.frame.width/2 < 0){
            t3.center.x = t2.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 3)
        }
        
        if(t4.center.x + t3.frame.width/2 < 0){
            t4.center.x = t3.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 4)
            
        }
        
        if(t5.center.x + t4.frame.width/2 < 0){
            t5.center.x = t4.center.x + t1.frame.width + 10
            refreashTicker(currentTicker: 5)
            
        }
        
        if(t6.center.x + t5.frame.width/2 < 0){
            t6.center.x = t5.center.x + t1.frame.width + 10
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
        if(currentTicker == 1){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
  
                    self.t1Name.text = myJson["symbol"].stringValue
                    self.t1Price.text = "$\(String(format: "%.2f", Float64(myJson["high"].stringValue) ?? " "))"
                    self.t1Change.text = "\(String(format: "%.2f", Float64(myJson["changePercent"].stringValue) ?? " "))"
                    
                    if myJson["changePercent"].floatValue > 0{
                        self.t1Picture.text = pictures.up.rawValue
                    }else if myJson["changePercent"].floatValue < 0{
                        self.t1Picture.text = pictures.down.rawValue
                    }else {
                        self.t1Picture.text = pictures.stable.rawValue
                    }
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
        }
        
        if(currentTicker == 2){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
                    
                    self.t2Name.text = myJson["symbol"].stringValue
                    self.t2Price.text = "$\(String(format: "%.2f", Float64(myJson["high"].stringValue) ?? " "))"
                    self.t2Change.text = "\(String(format: "%.2f", Float64(myJson["changePercent"].stringValue) ?? " "))"
                    
                    if myJson["changePercent"].floatValue > 0{
                        self.t2Picture.text = pictures.up.rawValue
                    }else if myJson["changePercent"].floatValue < 0{
                        self.t2Picture.text = pictures.down.rawValue
                    }else {
                        self.t2Picture.text = pictures.stable.rawValue
                    }
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
            
        }
        
        if(currentTicker == 3){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
                    
                    self.t3Name.text = myJson["symbol"].stringValue
                    self.t3Price.text = "$\(String(format: "%.2f", Float64(myJson["high"].stringValue) ?? " "))"
                    self.t3Change.text = "\(String(format: "%.2f", Float64(myJson["changePercent"].stringValue) ?? " "))"
                    
                    if myJson["changePercent"].floatValue > 0{
                        self.t3Picture.text = pictures.up.rawValue
                    }else if myJson["changePercent"].floatValue < 0{
                        self.t3Picture.text = pictures.down.rawValue
                    }else {
                        self.t3Picture.text = pictures.stable.rawValue
                    }
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
            
        }
        
        if(currentTicker == 4){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
                    
                    self.t4Name.text = myJson["symbol"].stringValue
                    self.t4Price.text = "$\(String(format: "%.2f", Float64(myJson["high"].stringValue) ?? " "))"
                    self.t4Change.text = "\(String(format: "%.2f", Float64(myJson["changePercent"].stringValue) ?? " "))"
                    
                    if myJson["changePercent"].floatValue > 0{
                        self.t4Picture.text = pictures.up.rawValue
                    }else if myJson["changePercent"].floatValue < 0{
                        self.t4Picture.text = pictures.down.rawValue
                    }else {
                        self.t4Picture.text = pictures.stable.rawValue
                    }
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
            
        }
        
        if(currentTicker == 5){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
                    
                    self.t5Name.text = myJson["symbol"].stringValue
                    self.t5Price.text = "$\(String(format: "%.2f", Float64(myJson["high"].stringValue) ?? " "))"
                    self.t5Change.text = "\(String(format: "%.2f", Float64(myJson["changePercent"].stringValue) ?? " "))"
                    
                    if myJson["changePercent"].floatValue > 0{
                        self.t5Picture.text = pictures.up.rawValue
                    }else if myJson["changePercent"].floatValue < 0{
                        self.t5Picture.text = pictures.down.rawValue
                    }else {
                        self.t5Picture.text = pictures.stable.rawValue
                    }
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
            
        }
        
        if(currentTicker == 6){
            
            let keyMarketStockString = keyMarketStock[Int(arc4random_uniform(UInt32(keyMarketStock.count)))]
            
            Alamofire.request("https://api.iextrading.com/1.0/stock/" + keyMarketStockString + "/quote").responseJSON { (response) in
                
                if let json = response.result.value {
                    let myJson = JSON(json)
                    
                    self.t6Name.text = myJson["symbol"].stringValue
                    self.t6Price.text = "$\(String(format: "%.2f", Float64(myJson["high"].stringValue) ?? " "))"
                    self.t6Change.text = "\(String(format: "%.2f", Float64(myJson["changePercent"].stringValue) ?? " "))"
                    
                    if myJson["changePercent"].floatValue > 0{
                        self.t6Picture.text = pictures.up.rawValue
                    }else if myJson["changePercent"].floatValue < 0{
                        self.t6Picture.text = pictures.down.rawValue
                    }else {
                        self.t6Picture.text = pictures.stable.rawValue
                    }
                    
                }else {
                    print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
                }
                if let data = response.data{
                    print("How much data was sent: \(data)")
                }
            }
            
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
                    
                    if each.1["quote"]["change"].floatValue > 0{
                        self.currentPicture = pictures.up.rawValue
                    }else if each.1["quote"]["change"].floatValue < 0{
                        self.currentPicture = pictures.down.rawValue
                    }else {
                        self.currentPicture = pictures.stable.rawValue
                    }
                    
                    let tickerValue = Ticker(name: each.1["quote"]["symbol"].stringValue,
                                             price: "$\(String(format: "%.2f", Float64(each.1["quote"]["high"].stringValue) ?? " "))",
                        change: "$\(String(format: "%.2f", Float64(each.1["quote"]["changePercent"].stringValue) ?? " "))",
                        picture : self.currentPicture)
                    
                    self.myTickers.append(tickerValue)
                }

                self.startingValue()
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("How much data was sent: \(data)")
            }
        }
    }
    
    func startingValue(){

        var i = 0
        while i <= myTickers.count {
            if(i == 0){
                t1Name.text = myTickers[i].name
                t1Price.text = myTickers[i].price
                t1Change.text = myTickers[i].change
                t1Picture.text = myTickers[i].picture
                ticker1.backgroundColor = UIColor.green
            }
            if(i == 1){
                t2Name.text = myTickers[i].name
                t2Price.text = myTickers[i].price
                t2Change.text = myTickers[i].change
                t2Picture.text = myTickers[i].picture
                ticker2.backgroundColor = UIColor.green
            }
            if(i == 2){
                t3Name.text = myTickers[i].name
                t3Change.text = myTickers[i].change
                t3Price.text = myTickers[i].price
                t3Picture.text = myTickers[i].picture
                ticker3.backgroundColor = UIColor.green
            }
            if(i == 3){
                t4Name.text = myTickers[i].name
                t4Change.text = myTickers[i].change
                t4Price.text = myTickers[i].price
                t4Picture.text = myTickers[i].picture
                ticker4.backgroundColor = UIColor.green
            }
            if(i == 4){
                t5Name.text = myTickers[i].name
                t5Change.text = myTickers[i].change
                t5Price.text = myTickers[i].price
                t5Picture.text = myTickers[i].picture
                ticker5.backgroundColor = UIColor.green
            }
            if(i == 5){
                t6Name.text = myTickers[i].name
                t6Change.text = myTickers[i].change
                t6Price.text = myTickers[i].price
                t6Picture.text = myTickers[i].picture
                ticker6.backgroundColor = UIColor.green
            }
            i += 1
        }
    }
    
    //tableview information
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        //ipos table
        if(tableView.tag == 1){
            count = IPOs.count
        }
        //movers table
        if(tableView.tag == 2){
            count = winners.count
        }
        //losers table
        if(tableView.tag == 3){
            count = losers.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        //ipos
        if(tableView.tag == 1){
            cell = ipoTableView.dequeueReusableCell(withIdentifier: "ipoCell", for: indexPath)
            
            if(IPOs.count == 0){
                cell.textLabel?.text = "No IPOs available at this time"
            }else
            {
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.numberOfLines = 0
                cell.textLabel?.text = "\(String(describing: IPOs[indexPath.row].companyName ?? "Null"))\n\(String(describing: IPOs[indexPath.row].symbol ?? "Null"))"
            
                cell.detailTextLabel?.text = "$\(String(describing: IPOs[indexPath.row].priceLow ?? "Null"))-\(String(describing: IPOs[indexPath.row].priceHigh ?? "Null"))\n\(String(describing: IPOs[indexPath.row].expectedDate ?? "Null"))"
            }
        }
        
        //movers
        if(tableView.tag == 2){
            cell = moversAndShakersTableView.dequeueReusableCell(withIdentifier: "moversAndShakerCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 0
            
            cell.textLabel?.text = "\(String(describing: winners[indexPath.row].companyName ?? "Null"))\n\(String(describing: winners[indexPath.row].symbol ?? "Null"))"
            //cell.detailTextLabel?.text = "$\(String(describing: winners[indexPath.row].latestPrice ?? "Null"))\n%\(String(describing: winners[indexPath.row].changePercent ?? "Null"))"
            
            cell.detailTextLabel?.text = "$\(String(format: "%.2f", Float64(winners[indexPath.row].latestPrice ?? "") ?? ""))\n%\(String(format: "%.2f", Float64(winners[indexPath.row].changePercent ?? "") ?? ""))"
        }
        
        //losers
        if(tableView.tag == 3){
            cell = losersTableView.dequeueReusableCell(withIdentifier: "losersCell", for: indexPath)
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(String(describing: losers[indexPath.row].companyName ?? "Null"))\n\(String(describing: losers[indexPath.row].symbol ?? "Null"))"
            cell.detailTextLabel?.text = "$\(String(describing: losers[indexPath.row].latestPrice ?? "Null"))\n\(String(describing: losers[indexPath.row].change ?? "Null"))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var heading: String = ""
        
        if(tableView.tag == 1){
            heading = "Upcoming IPOs"
        }
        if(tableView.tag == 2){
            heading = "Winners"
            //tableView.sectionIndexBackgroundColor = .black
            //tableView.backgroundColor = .black
        }
        if(tableView.tag == 3){
            heading = "Losers"
            
        }
        return heading
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        
        if(tableView.tag == 1){
            currentIndex = indexPath.row
            
            //create a specific IPO detail view
            performSegue(withIdentifier: "ipoDetails", sender: self)
            
            
        }
        
        if(tableView.tag == 2){
            currentIndex = indexPath.row
            
            performSegue(withIdentifier: "getWinnerDetails", sender: self)
            
            
        }
        
        //looks at makers table View
        if(tableView.tag == 3){
            currentIndex = indexPath.row
            performSegue(withIdentifier: "getLoserDetails", sender: self)
            
        }
        
    }
    
    //prepares the environment for the multiple possible segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //create a custom view for IPO processing
        if(segue.identifier == "ipoDetails"){
            let destVC: IPODetailsViewController = segue.destination as! IPODetailsViewController
            destVC.data = IPOs[currentIndex]
            
            //create a IPO view
        }
        
        
        //create a custom view for winners processing
        if(segue.identifier == "getWinnersDetails"){
            let destVC: TableViewDetailsViewController = segue.destination as! TableViewDetailsViewController
             destVC.data = winners[currentIndex]
            
        }
        
        //this will cover the markets
        if(segue.identifier == "getLoserDetails"){
            
            let destVC: TableViewDetailsViewController = segue.destination as! TableViewDetailsViewController
            destVC.data = losers[currentIndex]
            
        }
        
    }
    
    func collectMarketData(){
        
        SVProgressHUD.show()
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
            
            if each.0 == "rawData"{
            
            for item in each.1{
                var newIPOItem = IPO()
                
                newIPOItem.companyName = item.1["companyName"].stringValue
                newIPOItem.symbol = item.1["symbol"].stringValue
                newIPOItem.expectedDate = item.1["expectedDate"].stringValue
                newIPOItem.auditor = item.1["auditor"].stringValue
                newIPOItem.market = item.1["market"].stringValue
                newIPOItem.cik = item.1["cik"].stringValue
                newIPOItem.address = item.1["address"].stringValue
                newIPOItem.city = item.1["city"].stringValue
                newIPOItem.state = item.1["state"].stringValue
                newIPOItem.zip = item.1["zip"].stringValue
                newIPOItem.phone = item.1["phone"].stringValue
                newIPOItem.ceo = item.1["ceo"].stringValue
                newIPOItem.employees = item.1["employees"].stringValue
                newIPOItem.url = item.1["url"].stringValue
                newIPOItem.status = item.1["status"].stringValue
                newIPOItem.sharesOffered = item.1["sharesOffered"].stringValue
                newIPOItem.priceLow = item.1["priceLow"].stringValue
                newIPOItem.priceHigh = item.1["priceHigh"].stringValue
                newIPOItem.offerAmount = item.1["offerAmount"].stringValue
                newIPOItem.totalExpenses = item.1["totalExpenses"].stringValue
                newIPOItem.sharesOverAlloted = item.1["sharesOverAlloted"].stringValue
                newIPOItem.shareholderShares = item.1["shareholderShares"].stringValue
                newIPOItem.sharesOutstanding = item.1["sharesOutstanding"].stringValue
                newIPOItem.lockupPeriodExpiration = item.1["lockupPeriodExpiration"].stringValue
                newIPOItem.quietPeriodExpiration = item.1["quietPeriodExpiration"].stringValue
                newIPOItem.revenue = item.1["revenue"].stringValue
                newIPOItem.netIncome = item.1["netIncome"].stringValue
                newIPOItem.totalAssets = item.1["totalAssets"].stringValue
                newIPOItem.totalLiabilities = item.1["totalLiabilities"].stringValue
                newIPOItem.stockholderEquity = item.1["stockholderEquity"].stringValue
                newIPOItem.companyDescription = item.1["companyDescription"].stringValue
                newIPOItem.businessDescription = item.1["businessDescription"].stringValue
                newIPOItem.useOfProceeds = item.1["useOfProceeds"].stringValue
                newIPOItem.competition = item.1["competition"].stringValue
                newIPOItem.amount = item.1["amount"].stringValue
                newIPOItem.percentOffered = item.1["percentOffered"].stringValue
                
                for eachItem in item.1["leadUnderwriters"]{
                    let myUnderWriter = eachItem.1.stringValue
    
                    newIPOItem.leadUnderwriters.append(myUnderWriter)
                }
                
                for eachItem in item.1["underwriters"]{
                    let myUnderWriter = eachItem.1.stringValue
                    
                    newIPOItem.underwriters.append(myUnderWriter)
                }
                
                for eachItem in item.1["companyCounsel"]{
                    let myUnderWriter = eachItem.1.stringValue
                    
                    newIPOItem.companyCounsel.append(myUnderWriter)
                }
                
                for eachItem in item.1["underwriterCounsel"]{
                    let myUnderWriter = eachItem.1.stringValue
                    
                    newIPOItem.underwriterCounsel.append(myUnderWriter)
                }
                
                IPOs.append(newIPOItem)
            }
            
        }
        
        }
        print("This is how many items within IPOs: \(IPOs.count)")
        
        SVProgressHUD.dismiss()
        ipoTableView.reloadData()
    }
    
    func processMoversData(json : JSON){

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
            
          //  print(myStocks.companyName)
            winners.append(myStocks)
        }
        
        moversAndShakersTableView.reloadData()
    }
    
    func processLosersData(json : JSON){
        
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
            
            losers.append(myStocks)
        }
        
        losersTableView.reloadData()
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
