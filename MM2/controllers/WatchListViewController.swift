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
import SVProgressHUD

class WatchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITabBarControllerDelegate {
    
  //tab bar stuff
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
       if tabBarController.selectedIndex == 2 {
        
        if let userArray = myDefaults.object(forKey: "userWatchList") as? [String]{
           
            for item in userArray{
                
                if watchListItems.contains(item){
                    //do nothing
                    print("do nothing")
                    formatedWatchList = ""
                }else{
                    //add item
                    print("the answer to this is: \(watchListItems.contains(item))")
                    watchListItems.append(item)
                    formatedWatchList = ""
                }
            }
            
            formatedWatchList = ""
            
            for each in watchListItems{
                formatedWatchList = formatedWatchList + each + ","
            }
            
            
            watchListStocks.removeAll()
            
            SVProgressHUD.show()

            Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10").responseJSON { (response) in
                
                //validate that i am requesting all the data
                print("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(self.formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10")
                
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
            
        }else {
            //no watchlist items found
            // displayAlert()
            watchListStocks[0].symbol = "No stock found, please add stocks to watchlist"
            watchListStocks[0].latestPrice = ""
            
            }
        }
    }
    
    
    //table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return watchListStocks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = watchListTableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        
       
        if watchListStocks.count == 0 {
            
            cell.textLabel?.text = "Please search for and Add stocks to your Watchlist"
            cell.detailTextLabel?.text = ""
            
        }else {
            
            cell.textLabel?.text = "\(String(describing: watchListStocks[indexPath.row].companyName ?? "Please search for and Add stocks to your Watchlist"))\n\(String(describing: watchListStocks[indexPath.row].symbol ?? ""))"
            
            cell.detailTextLabel?.text = "$\(String(format: "%.2f", Float64(watchListStocks[indexPath.row].latestPrice ?? "") ?? ""))"
            
        }
        return cell
    }
    
    //delete cell from watchlist
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            //deletion from tableview
            watchListStocks.remove(at: indexPath.row)
            watchListItems.remove(at: indexPath.row)
            watchListTableView.deleteRows(at: [indexPath], with: .fade)
            myDefaults.set(watchListItems, forKey: "userWatchList")
            watchListTableView.reloadData()
        }
    }
    
    //removed the option to delete the watchList for now
    @IBAction func deleteWatchList(_ sender: UIBarButtonItem) {
        
       // watchListStocks.removeAll()
       // watchListTableView.reloadData()
       // watchListItems.removeAll()
       // myDefaults.set(watchListItems, forKey: "userWatchList")
        
        displayAlerts()
       // watchListTableView.reloadData()
    }
    
    
    func displayAlerts(){
        
        let continueAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            self.watchListStocks.removeAll()
            self.watchListItems.removeAll()
            self.myDefaults.set(self.watchListItems, forKey: "userWatchList")
            self.watchListTableView.reloadData()
            self.dismiss(animated: true, completion: nil)
           
            // self.watchListTableView.ce
        }
        
        let cancelAction = UIAlertAction(title: "Stop/Cancel", style: .cancel) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let deleteWatchListAlert = UIAlertController(title: "Warning", message: "Continue to delete your watchList!", preferredStyle: .alert)
        deleteWatchListAlert.addAction(continueAction)
        deleteWatchListAlert.addAction(cancelAction)
        
        self.present(deleteWatchListAlert, animated: true, completion: nil)
        
    }
    
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
    
    var keyMarketStock = ["dia","spy", "fb", "aapl", "goog", "good", "ibm","msft","amd","GE","NLNK", "WVE", "IPLDP", "IGBH", "HURC", "ZIXI", "NMY", "FTK", "PAR", "RDI", "BRPA", "MBG", "APOPW", "GREK", "AMH-G", "COE", "MOM", "UIVM", "AUTO", "CLGX", "BFR", "IVR-C", "FWRD", "ANF", "ROK", "QQXT", "YGRN", "GMAN", "SPLP-A", "GLTR", "KLAC", "VTIP", "AFI", "IBN", "DF", "RENN", "GOGL", "GULF", "PFSI", "RVT", "UL", "MTB-C", "FLAG", "XPH", "SWP", "ZNH", "OPOF", "XLSR", "ESBK", "BPFH", "ECCX", "WTRU", "CWCO", "NGL-C", "IPFF", "ALB", "PSCH", "EBAY", "RAIL", "PYPE", "IBMH", "HYGV", "ZAGG", "MLPZ", "ISIG", "AFC", "JAGX", "TAIL", "ARKR", "WFC-X", "RYE", "GOEX", "DON", "PFH", "LOGM", "ATHM", "RCA", "GTN.A", "MVIS", "MELR", "FWONK", "SLAB", "EGOV", "NUDM", "CGA", "COOP", "AGI", "BYFC", "RMR", "GLADN", "HWC", "FRBA", "ITIC", "LBRDK", "OCIO", "FV", "NSIT", "KBWP", "SLP", "PCG-D", "NCB", "TDS", "PPR", "EET", "FNDC", "FTI", "AVB", "MMAC", "NUMG", "BANR", "KIQ", "MANH", "SLGG", "PSA-G", "DYNF", "SLNO", "POWL", "STL-A", "DYNC", "VBR", "JO", "OIL", "ZDEU", "MNCLU", "LEMB", "GHG", "PRAA", "UYG", "PFBI", "AGT", "RYN", "ASUR", "TFLO", "FIS", "PULS", "TGI", "YMAB", "PNW", "ESGU", "SNV", "DHXM", "RBC", "UNB", "BRPAU", "LEGR", "NLY-F", "SPFI", "STBA", "ENIC", "WTS", "INBKL", "CVI", "VNRX", "CEV", "BOTZ", "NEE-N", "SYNA", "DS-B", "HGV", "PRNT", "RTN", "TD", "PAGS", "FLIN", "FCAU", "BCEI", "MGEN", "SOGO", "BYLD", "BUYN", "IHT", "ARCH", "CTZ", "CHSCP", "GD", "CLLS", "PEI", "RF-C", "CSL", "NUE", "AAU", "CANF", "ISEE", "FRGI", "KREF", "SOVB", "DKL", "ALE", "GS-C", "MYN", "GPS", "FLQD", "JBR", "LSXMA", "SCWX", "BSCE", "BTX", "AMBR", "NBR-A", "HCCHR", "HAIR"]
    var myTickers = [Ticker]()
    var mySortedTickers = [Ticker]()
    var myTimer = Timer()
    var lastTicker = CGFloat()
    var timing = 0
    var timingCount = 0
    var newTimer = Timer()
    var currentPicture = ""
    
    enum pictures: String {
        case up = "💹"
        case down = "🔻"
        case stable = "⎯"
        case onFire = "🔥"
        case cold = "❄️"
    }
    
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
            ticker1.center.x = ticker6.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 1)
        }
        
        if(ticker2.center.x + ticker2.frame.width/2 < 0){
            ticker2.center.x = ticker1.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 2)
        }
        
        if(ticker3.center.x + ticker3.frame.width/2 < 0){
            ticker3.center.x = ticker2.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 3)
        }
    
        if(ticker4.center.x + ticker3.frame.width/2 < 0){
            ticker4.center.x = ticker3.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 4)
            
        }
        
        if(ticker5.center.x + ticker4.frame.width/2 < 0){
            ticker5.center.x = ticker4.center.x + ticker1.frame.width + 10
            refreashTicker(currentTicker: 5)
            
        }
        
        if(ticker6.center.x + ticker5.frame.width/2 < 0){
            ticker6.center.x = ticker5.center.x + ticker1.frame.width + 10
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
    
    //helper functions
    func viewSetup(){
        if let userArray = myDefaults.object(forKey: "userWatchList") as? [String]{
            watchListItems.append(contentsOf: userArray)

            for each in watchListItems{
                formatedWatchList = formatedWatchList + each + ","
            }
           // print("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10")
        }
        /*
        else {
            //no watchlist items found
           // displayAlert()
            watchListStocks[0].symbol = "No stock found, please add stocks to watchlist"
            watchListStocks[0].latestPrice = ""
            
        }
     */
        watchListTableView.reloadData()
        
    }
    
    
    func displayAlert()-> String{
    //make the table view display nothing
        
        
        
        return "Search for and Add stocks to your WatchList!! "
    }
    
    // end of code cut
    func networkCall(){
        
        viewSetup()
        
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10").responseJSON { (response) in
           
            //validate that i am requesting all the data
            print("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(self.formatedWatchList)&types=quote,financials,earnings,logo,news,chart&range=1m&last=10")
            
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
                        myChart.open = item.1["open"].doubleValue
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
        SVProgressHUD.dismiss()
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
        
       self.tabBarController?.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    


}
