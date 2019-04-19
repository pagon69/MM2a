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
