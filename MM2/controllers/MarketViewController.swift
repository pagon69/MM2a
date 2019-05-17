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
import GoogleMobileAds
import SVProgressHUD

class MarketViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITabBarControllerDelegate {
    
    //detect touches and do something
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //used to get the position
        if let touch = touches.first {
            let position = touch.location(in: t1)
            print("This is the current position, within toches ends: \(position)")
            
            // can i detect which view?
            touch.location(in: t1)
            
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let position = touch.location(in: t1)
            print("This is the current position, within touches began: \(position)")
            
            // can i detect which view?
            touch.location(in: t1)
            
        }
        
        
    }
    
    //tab bar dcontroller stuff
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarItem = tabBarController.selectedIndex
        
        print("in tab bar with an index of \(tabBarController.selectedIndex)")
 
        if tabBarItem == 2 {
            print("run the refresh code")
        }
        
    }

    //sections and table customization
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var heading: String = ""
        
        if(tableView.tag == 1){
            heading = "Major ETF/Indexes"
        }
        if(tableView.tag == 2){
            heading = "Exchanges"
        }
        return heading
    }
    
    //used to set the header and footers view and color
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.black
        //view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        
    }
    
    
    
    //Table view stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if(tableView.tag == 0){
            count = searchResults?.count ?? 1
        }
 
        //Index table
        if(tableView.tag == 1){
            count = marketStocks.count
        }
        
        //Markets
        if(tableView.tag == 2){
            count = myMarkets.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()

        if(tableView.tag == 1){
            cell = marketOutlet.dequeueReusableCell(withIdentifier: "marketsCell", for: indexPath)

            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(String(describing: marketStocks[indexPath.row].companyName ?? "Something went wrong"))\n\(String(describing: marketStocks[indexPath.row].symbol ?? "Something went wrong" ))"
            
            if let change = Float(marketStocks[indexPath.row].change ?? ""){
                
                if Float(change) >= 0.0 && Float(change) <= 1.99{
                    cell.detailTextLabel?.numberOfLines = 0
                    
                    cell.detailTextLabel?.text = "$\(String(format: "%.2f", Float64(marketStocks[indexPath.row].latestPrice ?? "") ?? ""))\n\(pictures.up.rawValue) \(String(format: "%.2f", Float64(marketStocks[indexPath.row].change ?? "") ?? ""))"
                    
                }else if Float(change) <= 0.0{
                    cell.detailTextLabel?.numberOfLines = 0

                    cell.detailTextLabel?.text = "$\(String(format: "%.2f", Float64(marketStocks[indexPath.row].latestPrice ?? "") ?? ""))\n\(pictures.down.rawValue) \(String(format: "%.2f", Float64(marketStocks[indexPath.row].change ?? "") ?? ""))"
                }else if Float(change) >= 2{
                
                    cell.detailTextLabel?.numberOfLines = 0

                    cell.detailTextLabel?.text = "$\(String(format: "%.2f", Float64(marketStocks[indexPath.row].latestPrice ?? "") ?? ""))\n\(pictures.onFire.rawValue) \(String(format: "%.2f", Float64(marketStocks[indexPath.row].change ?? "") ?? ""))"
                }else{
                    cell.detailTextLabel?.numberOfLines = 0
                    
                    cell.detailTextLabel?.text = "$\(String(format: "%.2f", Float64(marketStocks[indexPath.row].latestPrice ?? "") ?? ""))\n\(pictures.stable.rawValue) \(String(format: "%.2f", Float64(marketStocks[indexPath.row].change ?? "") ?? ""))"
                }
            }
        }
        
        //markets
        if(tableView.tag == 2){
            cell = makerOutlet.dequeueReusableCell(withIdentifier: "makersCell", for: indexPath)
        
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(myMarkets[indexPath.row].venueName)\nVolume: \(myMarkets[indexPath.row].volume)"

                cell.detailTextLabel?.text = "\(String(format: "%.3f", Float64(myMarkets[indexPath.row].marketPercent ?? "") ?? ""))%"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //looks at markets tableView
        if(tableView.tag == 1){
            currentIndexPath = indexPath.row
            performSegue(withIdentifier: "goToTableViewDetail", sender: self)
            
            
        }
        
        //looks at makers table View
        if(tableView.tag == 2){
            currentIndexPath = indexPath.row
            performSegue(withIdentifier: "goToMakersDetail", sender: self)
            
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
            destVC.data = marketStocks[currentIndexPath]
            
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
    
    //google banners
    @IBOutlet weak var GoogleAdOutlet: GADBannerView!
    
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
    
    //my global variables

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
    var currentPicture = ""
    
    enum pictures: String {
        case up = "💹"
        case down = "🔻"
        case stable = "⎯"
        case onFire = "🔥"
        case cold = "❄️"
    }
    
    //below is needed for ticker
    var keyMarketStock = ["dia","spy", "fb", "aapl", "goog", "good", "ibm","msft","amd","GE","NLNK", "WVE", "IPLDP", "IGBH", "HURC", "ZIXI", "NMY", "FTK", "PAR", "RDI", "BRPA", "MBG", "APOPW", "GREK", "AMH-G", "COE", "MOM", "UIVM", "AUTO", "CLGX", "BFR", "IVR-C", "FWRD", "ANF", "ROK", "QQXT", "YGRN", "GMAN", "SPLP-A", "GLTR", "KLAC", "VTIP", "AFI", "IBN", "DF", "RENN", "GOGL", "GULF", "PFSI", "RVT", "UL", "MTB-C", "FLAG", "XPH", "SWP", "ZNH", "OPOF", "XLSR", "ESBK", "BPFH", "ECCX", "WTRU", "CWCO", "NGL-C", "IPFF", "ALB", "PSCH", "EBAY", "RAIL", "PYPE", "IBMH", "HYGV", "ZAGG", "MLPZ", "ISIG", "AFC", "JAGX", "TAIL", "ARKR", "WFC-X", "RYE", "GOEX", "DON", "PFH", "LOGM", "ATHM", "RCA", "GTN.A", "MVIS", "MELR", "FWONK", "SLAB", "EGOV", "NUDM", "CGA", "COOP", "AGI", "BYFC", "RMR", "GLADN", "HWC", "FRBA", "ITIC", "LBRDK", "OCIO", "FV", "NSIT", "KBWP", "SLP", "PCG-D", "NCB", "TDS", "PPR", "EET", "FNDC", "FTI", "AVB", "MMAC", "NUMG", "BANR", "KIQ", "MANH", "SLGG", "PSA-G", "DYNF", "SLNO", "POWL", "STL-A", "DYNC", "VBR", "JO", "OIL", "ZDEU", "MNCLU", "LEMB", "GHG", "PRAA", "UYG", "PFBI", "AGT", "RYN", "ASUR", "TFLO", "FIS", "PULS", "TGI", "YMAB", "PNW", "ESGU", "SNV", "DHXM", "RBC", "UNB", "BRPAU", "LEGR", "NLY-F", "SPFI", "STBA", "ENIC", "WTS", "INBKL", "CVI", "VNRX", "CEV", "BOTZ", "NEE-N", "SYNA", "DS-B", "HGV", "PRNT", "RTN", "TD", "PAGS", "FLIN", "FCAU", "BCEI", "MGEN", "SOGO", "BYLD", "BUYN", "IHT", "ARCH", "CTZ", "CHSCP", "GD", "CLLS", "PEI", "RF-C", "CSL", "NUE", "AAU", "CANF", "ISEE", "FRGI", "KREF", "SOVB", "DKL", "ALE", "GS-C", "MYN", "GPS", "FLQD", "JBR", "LSXMA", "SCWX", "BSCE", "BTX", "AMBR", "NBR-A", "HCCHR", "HAIR"]
    
    var myTickers = [Ticker]()
    var mySortedTickers = [Ticker]()
    
    
    //functions needed for Ticker
    func startAnimating(){
        timing += 1
        t1.center.x = t1.center.x  - 3
        t2.center.x = t2.center.x  - 3
        t3.center.x = t3.center.x  - 3
        t4.center.x = t4.center.x  - 3
        t5.center.x = t5.center.x  - 3
        t6.center.x = t6.center.x  - 3
        
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
                t1.backgroundColor = UIColor.green
            }
            if(i == 1){
                t2Name.text = myTickers[i].name
                t2Price.text = myTickers[i].price
                t2Change.text = myTickers[i].change
                t2Picture.text = myTickers[i].picture
                t2.backgroundColor = UIColor.green
            }
            if(i == 2){
                t3Name.text = myTickers[i].name
                t3Change.text = myTickers[i].change
                t3Price.text = myTickers[i].price
                t3Picture.text = myTickers[i].picture
                t3.backgroundColor = UIColor.green
            }
            if(i == 3){
                t4Name.text = myTickers[i].name
                t4Change.text = myTickers[i].change
                t4Price.text = myTickers[i].price
                t4Picture.text = myTickers[i].picture
                t4.backgroundColor = UIColor.green
            }
            if(i == 4){
                t5Name.text = myTickers[i].name
                t5Change.text = myTickers[i].change
                t5Price.text = myTickers[i].price
                t5Picture.text = myTickers[i].picture
                t5.backgroundColor = UIColor.green
            }
            if(i == 5){
                t6Name.text = myTickers[i].name
                t6Change.text = myTickers[i].change
                t6Price.text = myTickers[i].price
                t6Picture.text = myTickers[i].picture
                t6.backgroundColor = UIColor.green
            }
            i += 1
        }
    }
    
    
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
        
        // ETFs i am aware of, like indices but free to display the data
       // ["rcmp", "dia","spy", "iwm", "v00", "ivv", "vti","spx","ixndx","rui","rut","oex","ndxe"]
        
        let keyMarkets = "djia,NASDAQ,n225,spy,dia,ndx,iwm,rcmp,voo,v00,ivv,vti,spx,ixndx,rui,rut,oex,ndxe"
        
        //network request for liquid markets
        Alamofire.request("https://api.iextrading.com/1.0/market").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                SVProgressHUD.show()
                self.processData(json: myJson)
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
        
        //https://api.iextrading.com/1.0/stock/market/list/mostactive/batch?symbols=\(keyMarkets)&types=quote,news,financials,logo,earnings,chart&range=1m&last=10
        
       //&types=quote,news,financials,logo,earnings,chart&range=1m&last=5
        //network request for Major indexices
        Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=\(keyMarkets)&types=quote,news,financials,logo,earnings,chart&range=1m&last=10").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                SVProgressHUD.show()
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
            let market = Markets(mic: each.1["mic"].stringValue, tapeId: each.1["tapeId"].stringValue, venueName: each.1["venueName"].stringValue, volume: each.1["volume"].stringValue, marketPercent: each.1["marketPercent"].stringValue, charts: [1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5], tapeA: each.1["tapeA"].stringValue, tapeB: each.1["tabeB"].stringValue, tapeC: each.1["tapeC"].stringValue, lastUpdated: each.1["lastUpdated"].stringValue)

            myMarkets.append(market)
        }
        
        SVProgressHUD.dismiss()
        marketOutlet.reloadData()
        makerOutlet.reloadData()
    }
    
    //processes data for the second table
    func processData2(json: JSON){
        
      //process the results
        for stocks in json{

            let myStocks = Stock()
            
            for each in stocks.1{
                
            if(each.0 == "news"){
                
                
                for item in each.1{
                    let myNews = News()
                    
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
            if(each.0 == "chart"){
    
                for item in each.1{
                    
                    let myChart = Chart()
                    
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
                
            if(each.0 == "logo"){
                myStocks.logo = each.1["url"].stringValue
               // print(myStocks.logo ?? "No logo available")
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
                
            }
        
            marketStocks.append(myStocks)

        }
        
        SVProgressHUD.dismiss()
        marketOutlet.reloadData()
        makerOutlet.reloadData()
    }

    func adsSetup() {
        GoogleAdOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        GoogleAdOutlet.rootViewController = self
        GoogleAdOutlet.load(GADRequest())
    }
    
    func createKey() {
        
        var myStringArray = [String]()
        
        Alamofire.request("https://api.iextrading.com/1.0/tops").responseJSON { (response) in
            if let json = response.result.value {
                let myJson = JSON(json)
                //SVProgressHUD.show()
               //self.processData2(json: myJson)
                for each in myJson{
                    if(myStringArray.count > 200){
                        print(myStringArray)
                        self.keyMarketStock = myStringArray
                        break
                    }else {
                        myStringArray.append(each.1["symbol"].stringValue)
                    }
                }
                
                
            }else {
                print("Somethign went wrong, check out the exact error msg: \(String(describing: response.error))")
            }
            if let data = response.data{
                print("Got data, this much was sent: \(data)")
            }
        }
        
    }
    
    
    
    // start of all runtime stuff
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self

        adsSetup()
        startPosition()
        
        myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.startAnimating()
        })
        
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
        
        //remove this code after i create a list.
       // createKey()
        
        
        
    }

}
