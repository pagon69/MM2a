//
//  TableViewDetailsViewController.swift
//  MM2
//
//  Created by user147645 on 3/27/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleMobileAds
import Charts
import SVProgressHUD
import SwiftyJSON

class TableViewDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    //collectionView setup
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return myArray.count
        //print("how many items in this data:\(data?.newsData.count ?? 1)")
       // return my2Array.count
        return data?.newsData.count ?? 1
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewOutlet.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! NewsCell
        
        cell.backgroundColor = UIColor.white
        
        cell.titleOutlet.text = data?.newsData[indexPath.row].headline
        cell.referencesOutlet.text = "Date:\(String(describing: data?.newsData[indexPath.row].datetime ?? "Nope")), Source:\(String(describing: data?.newsData[indexPath.row].source ?? "Nothing")), Related:\(String(describing: data?.newsData[indexPath.row].related ?? "what now"))"
        
        cell.summaryOutlet.text = data?.newsData[indexPath.row].summary
   
        //can i add this someplace?
       // cell.cellURL.text = data?.newsData[indexPath.row].url
        
        //need to call a image download when this happens
    
        if data?.newsData.isEmpty ?? true{
            cell.newsImageOutlet.image = downloadNewsPictures(locationString: data?.newsData[indexPath.row].image ?? " No Logo Available")
            cell.titleOutlet.text = "No news avialable for \(String(describing: data?.companyName))"
        }
        return cell
    }
 
    //sections for my various table views
    func numberOfSections(in tableView: UITableView) -> Int {
        //var count = 0
        
        //if(tableView.tag == 0){
            
        //}
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var heading: String = ""
        
        if(tableView.tag == 0){
            heading = "General Details for: \(String(describing: data?.companyName ?? ""))"
        }
        
        if(tableView.tag == 2){
            heading = "Financial Details for: \(String(describing: data?.companyName ?? ""))"
        }
        
        if(tableView.tag == 6){
            heading = "Earning data for: \(String(describing: data?.companyName ?? ""))"
        }
        
        if(tableView.tag == 1){
            heading = "Related News:"
        }
        
        return heading
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.black
        //view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        
    }
    
    //table view cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        //details view
        if(tableView.tag == 0){
           count = myNamesArray.count
            
        }
        
        //earnings
        if(tableView.tag == 1){
            
            count = earningsArray.count
        }
        
        //financial
        if(tableView.tag == 2){
            count = financialsArray.count
            
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        //details tableview
        if(tableView.tag == 0){
        cell = detailsTableViewOutlet.dequeueReusableCell(withIdentifier: "detailsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = myNamesArray[indexPath.row]
        cell.detailTextLabel?.text = myDetailsArray[indexPath.row]
        }
        
        //earnings tableview
        if(tableView.tag == 6){
            cell = earningsTableviewOutlet.dequeueReusableCell(withIdentifier: "earningsCell", for: indexPath)
            
            if earningsArray.isEmpty {
                cell.textLabel?.text = "No provided Data"
                cell.detailTextLabel?.text = ""
            }else {
                cell.textLabel?.text = earningsnames[indexPath.row]
                cell.detailTextLabel?.text = earningsArray[indexPath.row]
            }
            
        }
        
        //financial tableview
        if(tableView.tag == 2){
            cell = financialTableviewOutlet.dequeueReusableCell(withIdentifier: "financialCell", for: indexPath)
            
            cell.textLabel?.text = financialNames[indexPath.row]
            cell.detailTextLabel?.text = currentQuarterData[indexPath.row]
            
        }
        
            
        return cell
    }
    

    
    
    //gloabals
    var data: Stock?
    var data2: String?
    
    //use a dictionary for this part versus two arrays
    var myArray = [String]()
    
    var myDetailsArray = [String]()
    var earningsArray = [String]()
    
    
    //used to allow for quarterly data
    var financialsArray = [String]()
    var financialsArray2 = [String]()
    var financialsArray3 = [String]()
    var financialsArray4 = [String]()
    
    var currentQuarterData = [String]()

    var myFinancialsArray = [[String]]()
   
    let myNamesArray = ["Symbol","Company Name","Sector","Primary Exchange","Calculation price","Open","Close","High","52 Week High","Low","52 Week Low","Previous Close","Lastest price","Latest Source","Latest Volume","IEX RealTimePrice","IEX RealTimeSize","Delayed Price","extended Price","extended Change","extended change percent","change", "change percent","IEX Market Percent", "IEX Volume", "Avg Total Volume", "IEX Bid Price","IEX Ask Price","IEX Ask Size","Market cap","Pe Ratio","YTD Change" ]
    
    let earningsnames = [ "actualEPS", "consensusEPS", "estimatedEPS","announceTime","numberOfEstimates","EPSSurpriseDollar","EPSReportDate","fiscalPeriod","FiscalEndDate","yearAgo","yearAgoChangePercent","estimatedChangePercent","symbolId"]
    
    let financialNames = ["report Date","Gross Profit","Cost of revenue","Operating Revenue","Total Revenue","Operating Income","Net Income","Research and Development","Operating Expense","Current Assets","Total Assets","Total Liabilities","Current Cash","Current Debt","Total debt","ShareHolder Equity","Cash Change", "Cash Flow","Operating Gains and Losses"]
    
    var myRandomData = [10.0,20.0,30.0,25.0,100.0,345.0,5.0]
    
    var changeIconUp = "🔺"
    var changeIconDown = "🔻"
    
    var watchListItems = [String]()
    let myDefaults = UserDefaults.standard
    
    var userSelectedStock = [Stock]()
    var userSelectedStockTwo: Stock?
    
    var timingCount = 0
    var myTimer = Timer()
    
    //charts outlet
    @IBOutlet weak var combinedChartsOutlet: BarChartView!
    @IBOutlet weak var pieChartOutlet: PieChartView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    
    //watchlist addition button
    @IBAction func addToWatchList(_ sender: UIBarButtonItem) {
      
        if let userArray = myDefaults.object(forKey: "userWatchList") as? [String]{
            let myUserValue = (data?.symbol ?? "Null")
            if(userArray.contains(myUserValue)){
                displayAlert(alertMessage: "\(data?.symbol ?? "Null") is already on the WatchList", resultsMessage: "🛑")
            }else{
                watchListItems.append(contentsOf: userArray)
                watchListItems.append(myUserValue)
                displayAlert(alertMessage: "Adding \(data?.symbol ?? "Null") to WatchList.", resultsMessage: "✅")
                watchListItems.sort()
                myDefaults.set(watchListItems, forKey: "userWatchList")
                print("myDefaults found, newly added value not within array so adding it.")
            }
            
        }else{ //did not find the userwatchlist,
            let myUserValue = (data?.symbol ?? "Null")
            //watchListItems.sort()
            if(watchListItems.contains(myUserValue)){
                displayAlert(alertMessage: "\(data?.symbol ?? "Null") is currently in the WatchList", resultsMessage: "🛑")
            }else{
                //add to list
                watchListItems.append(myUserValue)
                displayAlert(alertMessage: "Adding \(data?.symbol ?? "Null") to your WatchList.", resultsMessage: "✅")
                myDefaults.set(watchListItems, forKey: "userWatchList")
                print("the watchlist didnt exist in my defaults and the stock wasnt in there")
            }
        }
        
        print("this is what should be saved in the watchlist: \(watchListItems)")
        
    }
    
    
    func displayAlert(alertMessage: String, resultsMessage: String){
        
        let myAlert = UIAlertController(title: alertMessage, message: resultsMessage, preferredStyle: .alert)
        
        present(myAlert, animated: true) {
            
            //displays an alert which disappears after 2 seconds
            self.myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.timingCount = self.timingCount + 1
                if(self.timingCount >= 1){
                    self.myTimer.invalidate()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    
    //outlets
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    //tableoutlets
    @IBOutlet weak var detailsTableViewOutlet: UITableView!
    @IBOutlet weak var earningsTableviewOutlet: UITableView!
    @IBOutlet weak var financialTableviewOutlet: UITableView!
    
    @IBOutlet weak var earningOutlet: UIView!
    @IBOutlet weak var detailsOutlet: UIView!
    @IBOutlet weak var financialOutlet: UIView!
    @IBOutlet weak var newsOutlet: UIView!
    @IBOutlet weak var viewControlsOutlet: UISegmentedControl!
    
    
    //title outlets
    @IBOutlet weak var titleImageViewoutlet: UIImageView!
    @IBOutlet weak var titleCompanyNameOutlet: UILabel!
    @IBOutlet weak var titlePriceAndChangeOutlet: UILabel!
    
    //google ads
    
    @IBOutlet weak var lastGoogleAd: GADBannerView!
    
    
    
    @IBAction func viewControls(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            print("in segment:\(sender.selectedSegmentIndex)")
            
            newsOutlet.isHidden = true
            financialOutlet.isHidden = true
            detailsOutlet.isHidden = false
            earningOutlet.isHidden = true
        }
        
        if(sender.selectedSegmentIndex == 1){
            print("in segment:\(sender.selectedSegmentIndex)")
            
            newsOutlet.isHidden = true
            financialOutlet.isHidden = true
            detailsOutlet.isHidden = true
            earningOutlet.isHidden = false
            
        }
        
        if(sender.selectedSegmentIndex == 2){
            print("in segment:\(sender.selectedSegmentIndex)")
            
            newsOutlet.isHidden = true
            financialOutlet.isHidden = false
            detailsOutlet.isHidden = true
            earningOutlet.isHidden = true
        }
        
        if(sender.selectedSegmentIndex == 3){
            print("in segment:\(sender.selectedSegmentIndex)")
            
            newsOutlet.isHidden = false
            financialOutlet.isHidden = true
            detailsOutlet.isHidden = true
            earningOutlet.isHidden = true
        }
    }
    
    //navigation options
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToSearch2", sender: self)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //future functions
    func viewSetup(){
        
        let change = ""
        
        //graph setup
        setupPieChart()
        
        //sets up the various views along with the segment controls
        self.newsOutlet.isHidden = true
        self.financialOutlet.isHidden = true
        self.detailsOutlet.isHidden = false
        self.earningOutlet.isHidden = true
        
        //sets up details
        
        setupDetailsView()
        setupFinancial()
        setupEarnings()

        
        
        if let testForBitCion = data?.sector {
            if testForBitCion == "cryptocurrency"{
                
            }else{
                buildCharts()
            }
            
        }
        
        
        //buildCharts()
        
        titleCompanyNameOutlet.text = data?.companyName
        titlePriceAndChangeOutlet.text = "\(String(describing: data?.latestPrice ?? "No data Available"))  \(change)  \(String(describing: data?.change ?? "No data Available"))"
        
        downloadPictures(locationString: data?.logo ?? "No Logo Available")
        
        detailsTableViewOutlet.reloadData()
        earningsTableviewOutlet.reloadData()
        financialTableviewOutlet.reloadData()
        
       // collectionViewOutlet.reloadData()
    }
    
    func addMissingData(){
        
        setupFinancial()
        setupEarnings()
        
    }
    
    
    
    func setupEarnings(){
        
        if let myEarningsData = data?.earningsData{
            
            if myEarningsData.isEmpty{
                
                if let stock = data?.symbol{
                    collectMissingData(stock: stock)
                }
                
 
            }else{
            
                for each in myEarningsData{
                    earningsArray.append(String(each.actualEPS ?? 1.0 ))
                    earningsArray.append(each.consensusEPS ?? "No data available" )
                    earningsArray.append(each.estimatedEPS ?? "No data available")
                    earningsArray.append(each.announceTime ?? "No data available")
                    earningsArray.append(each.numberOfEstimates ?? "No data available")
                    earningsArray.append(each.EPSSurpriseDollar ?? "No data available")
                    earningsArray.append(each.EPSReportDate ?? "No data available")
                    earningsArray.append(each.fiscalPeriod ?? "No data available")
                    earningsArray.append(each.FiscalEndDate ?? "No data available")
                    earningsArray.append(each.yearAgo ?? "No data available")
                    earningsArray.append(each.yearAgoChangePercent ?? "No data available")
                    earningsArray.append(each.estimatedChangePercent ?? "No data available")
                    earningsArray.append(each.symbolId ?? "No data available")
                }
            }
            
        }
        
        earningsTableviewOutlet.reloadData()
        
    }
    
    
    //need to all for multiple views, we have multiple quaters of data4 to be exact, maybe do a swithc to switch between
    func setupFinancial(){
        
        if let myFinancialData = data?.financialData{
            
            if myFinancialData.isEmpty{
                
                if let stock = data?.symbol{
                    collectMissingData(stock: stock)
                    
                  
                }
            }else {
                
            let q1Finance = myFinancialData[0]
            let q2Finance = myFinancialData[1]
            let q3Finance = myFinancialData[2]
            let q4Finance = myFinancialData[3]
            
            financialsArray.append(q1Finance.reportDate ?? "No data avialable")
            financialsArray.append(q1Finance.grossProfit ?? "No data avialable")
            financialsArray.append(q1Finance.costOfRevenue ?? "No data avialable")
            financialsArray.append(q1Finance.operatingRevenue ?? "No data avialable")
            financialsArray.append(q1Finance.totalRevenue ?? "No data avialable")
            financialsArray.append(q1Finance.operatingIncome ?? "No data avialable")
            financialsArray.append(q1Finance.netIncome ?? "No data avialable")
            financialsArray.append(q1Finance.researchAndDevlopment ?? "No data avialable")
            financialsArray.append(q1Finance.operatingexpense ?? "No data avialable")
            financialsArray.append(q1Finance.currentAssets ?? "No data avialable")
            financialsArray.append(q1Finance.totalAssets ?? "No data avialable")
            financialsArray.append(q1Finance.totalLiabilities ?? "No data avialable")
            financialsArray.append(q1Finance.currentCash ?? "No data avialable")
            financialsArray.append(q1Finance.currentDebt ?? "No data avialable")
            financialsArray.append(q1Finance.totalDebt ?? "No data avialable")
            financialsArray.append(q1Finance.shareholderEquity ?? "No data avialable")
            financialsArray.append(q1Finance.cashChange ?? "No data avialable")
            financialsArray.append(q1Finance.cashFlow ?? "No data avialable")
            financialsArray.append(q1Finance.operatingGainsLosses ?? "No data avialable")
            
            financialsArray2.append(q2Finance.reportDate ?? "No data avialable")
            financialsArray2.append(q2Finance.grossProfit ?? "No data avialable")
            financialsArray2.append(q2Finance.costOfRevenue ?? "No data avialable")
            financialsArray2.append(q2Finance.operatingRevenue ?? "No data avialable")
            financialsArray2.append(q2Finance.totalRevenue ?? "No data avialable")
            financialsArray2.append(q2Finance.operatingIncome ?? "No data avialable")
            financialsArray2.append(q2Finance.netIncome ?? "No data avialable")
            financialsArray2.append(q2Finance.researchAndDevlopment ?? "No data avialable")
            financialsArray2.append(q2Finance.operatingexpense ?? "No data avialable")
            financialsArray2.append(q2Finance.currentAssets ?? "No data avialable")
            financialsArray2.append(q2Finance.totalAssets ?? "No data avialable")
            financialsArray2.append(q2Finance.totalLiabilities ?? "No data avialable")
            financialsArray2.append(q2Finance.currentCash ?? "No data avialable")
            financialsArray2.append(q2Finance.currentDebt ?? "No data avialable")
            financialsArray2.append(q2Finance.totalDebt ?? "No data avialable")
            financialsArray2.append(q2Finance.shareholderEquity ?? "No data avialable")
            financialsArray2.append(q2Finance.cashChange ?? "No data avialable")
            financialsArray2.append(q2Finance.cashFlow ?? "No data avialable")
            financialsArray2.append(q2Finance.operatingGainsLosses ?? "No data avialable")
            
            financialsArray3.append(q3Finance.reportDate ?? "No data avialable")
            financialsArray3.append(q3Finance.grossProfit ?? "No data avialable")
            financialsArray3.append(q3Finance.costOfRevenue ?? "No data avialable")
            financialsArray3.append(q3Finance.operatingRevenue ?? "No data avialable")
            financialsArray3.append(q3Finance.totalRevenue ?? "No data avialable")
            financialsArray3.append(q3Finance.operatingIncome ?? "No data avialable")
            financialsArray3.append(q3Finance.netIncome ?? "No data avialable")
            financialsArray3.append(q3Finance.researchAndDevlopment ?? "No data avialable")
            financialsArray3.append(q3Finance.operatingexpense ?? "No data avialable")
            financialsArray3.append(q3Finance.currentAssets ?? "No data avialable")
            financialsArray3.append(q3Finance.totalAssets ?? "No data avialable")
            financialsArray3.append(q3Finance.totalLiabilities ?? "No data avialable")
            financialsArray3.append(q3Finance.currentCash ?? "No data avialable")
            financialsArray3.append(q3Finance.currentDebt ?? "No data avialable")
            financialsArray3.append(q3Finance.totalDebt ?? "No data avialable")
            financialsArray3.append(q3Finance.shareholderEquity ?? "No data avialable")
            financialsArray3.append(q3Finance.cashChange ?? "No data avialable")
            financialsArray3.append(q3Finance.cashFlow ?? "No data avialable")
            financialsArray3.append(q3Finance.operatingGainsLosses ?? "No data avialable")
            
            financialsArray4.append(q4Finance.reportDate ?? "No data avialable")
            financialsArray4.append(q4Finance.grossProfit ?? "No data avialable")
            financialsArray4.append(q4Finance.costOfRevenue ?? "No data avialable")
            financialsArray4.append(q4Finance.operatingRevenue ?? "No data avialable")
            financialsArray4.append(q4Finance.totalRevenue ?? "No data avialable")
            financialsArray4.append(q4Finance.operatingIncome ?? "No data avialable")
            financialsArray4.append(q4Finance.netIncome ?? "No data avialable")
            financialsArray4.append(q4Finance.researchAndDevlopment ?? "No data avialable")
            financialsArray4.append(q4Finance.operatingexpense ?? "No data avialable")
            financialsArray4.append(q4Finance.currentAssets ?? "No data avialable")
            financialsArray4.append(q4Finance.totalAssets ?? "No data avialable")
            financialsArray4.append(q4Finance.totalLiabilities ?? "No data avialable")
            financialsArray4.append(q4Finance.currentCash ?? "No data avialable")
            financialsArray4.append(q4Finance.currentDebt ?? "No data avialable")
            financialsArray4.append(q4Finance.totalDebt ?? "No data avialable")
            financialsArray4.append(q4Finance.shareholderEquity ?? "No data avialable")
            financialsArray4.append(q4Finance.cashChange ?? "No data avialable")
            financialsArray4.append(q4Finance.cashFlow ?? "No data avialable")
            financialsArray4.append(q4Finance.operatingGainsLosses ?? "No data avialable")
            
            currentQuarterData = financialsArray
            financialTableviewOutlet.reloadData()
            }
        }

       // financialTableviewOutlet.reloadData()
        
    }
    
    func setupDetailsView(){
        
        myDetailsArray.append(data?.symbol ?? "No Current Value")
        myDetailsArray.append(data?.companyName ?? "No Current Value")
        myDetailsArray.append(data?.sector ?? "No Current Value")
        myDetailsArray.append(data?.primaryExchange ?? "No Current Value")
        myDetailsArray.append(data?.calculationPrice ?? "No Current Value")
        myDetailsArray.append(data?.open ?? "No Current Value")
        myDetailsArray.append(data?.close ?? "No Current Value")
        myDetailsArray.append(data?.high ?? "No Current Value")
        myDetailsArray.append(data?.week52High ?? "No Current Value")
        myDetailsArray.append(data?.low ?? "No Current Value")
        myDetailsArray.append(data?.week52Low ?? "No Current Value")
        myDetailsArray.append(data?.previousClose ?? "No Current Value")
        myDetailsArray.append(data?.latestPrice ?? "No Current Value")
        myDetailsArray.append(data?.latestSource ?? "No Current Value")
        myDetailsArray.append(data?.latestVolume ?? "No Current Value")
        myDetailsArray.append(data?.iexRealTimePrice ?? "No Current Value")
        myDetailsArray.append(data?.ieRealtimeSize ?? "No Current Value")
        myDetailsArray.append(data?.delayedPrice ?? "No Current Value")
        myDetailsArray.append(data?.extendedPrice ?? "No Current Value")
        myDetailsArray.append(data?.extendedChange ?? "No Current Value")
        myDetailsArray.append(data?.extendedChangePercent ?? "No Current Value")
        myDetailsArray.append(data?.change ?? "No Current Value")
        myDetailsArray.append(data?.changePercent ?? "No Current Value")
        myDetailsArray.append(data?.iexMarketPercent ?? "No Current Value")
        myDetailsArray.append(data?.iexVolume ?? "No Current Value")
        myDetailsArray.append(data?.avgTotalVolume ?? "No Current Value")
        myDetailsArray.append(data?.iexBidPrice ?? "No Current Value")
        myDetailsArray.append(data?.iexAskPrice ?? "No Current Value")
        myDetailsArray.append(data?.iexAskSize ?? "No Current Value")
        myDetailsArray.append(data?.marketCap ?? "No Current Value")
        myDetailsArray.append(data?.peRation ?? "No Current Value")
        myDetailsArray.append(data?.ytdChange ?? "No Current Value")
        
        detailsTableViewOutlet.reloadData()
    }
    
    
    func downloadPictures(locationString: String){
        
        if locationString == "No Logo Available" {
            //put in a placeholder picture here
            
        }else{
            
            Alamofire.request(locationString).responseImage {response in
                
                if let image = response.result.value{
                    print("image downloaded: \(image)")
                    self.titleImageViewoutlet.image = image
                }
            }
        }
    }
    
    func downloadNewsPictures(locationString: String) -> UIImage{
        
        var myImage: UIImage = UIImage()
        
        if locationString == "No Logo Available" {
            //put in a placeholder picture here
            
        }else{
            
            Alamofire.request(locationString).responseImage {response in
                
                if let image = response.result.value{
                    //print("image downloaded: \(image)")
                    myImage = image
                }
            }
        }
        
        return myImage
    }
    
    
    func buildCharts2() {
        combinedChartsOutlet.noDataText = "No Data Available"
        var barDataEntries: [BarChartDataEntry] = []
       
        //var court = 0
        
        if data?.chartsData.isEmpty ?? true{
            
        let count = data?.chartsData.count ?? 0
        var myDataArray: [Double] = []
        
        // removes optionals from my data
        for i in 0..<count{
            if let myData = data?.chartsData[i].close{
                myDataArray.append(myData)
            }
        }
        
        for i in 0..<count{
            let barDataEntry = BarChartDataEntry(x: Double(i), y: myDataArray[i])
            barDataEntries.append(barDataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: barDataEntries, label: "Close over time")
        let chartData = BarChartData(dataSet: chartDataSet)
        combinedChartsOutlet.data = chartData
        combinedChartsOutlet.notifyDataSetChanged()
            
        SVProgressHUD.dismiss()
        
        }else {
            
            if let mySector = data?.sector{
            
                if mySector == "cryptocurrency"{
                    
                    print("do nothing this is a cryptocurrency")
                    
                }else{
                    
                    if let stock = data?.symbol{
                        collectMissingData(stock: stock)
                    
                }
            
                }
        }
        
        
        
    }
    }
    
    
    
    
    
    func buildCharts() {
        combinedChartsOutlet.noDataText = "No Data Available"
        var barDataEntries: [BarChartDataEntry] = []
        
        //var court = 0
        
        if data?.chartsData.isEmpty ?? true{
            
            if let mySector = data?.sector{
                
                if mySector == "cryptocurrency"{
                    
                    print("do nothing this is a cryptocurrency")
                    
                }else{
                    
                    if let stock = data?.symbol{
                        collectMissingData(stock: stock)
                        
                    }
                    
                }
            }
            
            
            
        }else {
            
            let count = data?.chartsData.count ?? 0
            var myDataArray: [Double] = []
            
            // removes optionals from my data
            for i in 0..<count{
                if let myData = data?.chartsData[i].close{
                    myDataArray.append(myData)
                }
            }
            
            for i in 0..<count{
                let barDataEntry = BarChartDataEntry(x: Double(i), y: myDataArray[i])
                barDataEntries.append(barDataEntry)
            }
            
            let chartDataSet = BarChartDataSet(values: barDataEntries, label: "Close over time")
            let chartData = BarChartData(dataSet: chartDataSet)
            combinedChartsOutlet.data = chartData
            combinedChartsOutlet.notifyDataSetChanged()
            
            SVProgressHUD.dismiss()
            
            
            
        }
    }
    
    
    
    
    
    //collect the needed chart, financial, etc data and more if it is not provided
    func collectMissingData(stock: String){
    
        if(data?.newsData.isEmpty ?? true && data?.financialData.isEmpty ?? true && data?.earningsData.isEmpty ?? true ){
       
            if(data?.sector == "cryptocurrency"){
            
            //if data?.sector == "cryptocurrency"
        print("do nothing")
        
        
            }else{
                
                Alamofire.request("https://api.iextrading.com/1.0/stock/market/batch?symbols=" + stock + "&types=quote,news,financials,logo,earnings,chart&range=1m&last=10").responseJSON { (response) in
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
                
                
            }
            
        
        }
        
    }
    
    
    
    //processes data for the market page
    func processData(json: JSON){
        //process the results
        //  print(json)
        for stocks in json{
            let myStocks = Stock()
            
            for each in stocks.1{
                
                //News processing
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
                //charts processing
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
                
                //logo processing
                if(each.0 == "logo"){
                    myStocks.logo = each.1["url"].stringValue
                    // print(myStocks.logo ?? "No logo available")
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
                            myFinancial.cashFlow = deeper.1["cashFlow"].stringValue
                            myFinancial.costOfRevenue = deeper.1["costOfRevenue"].stringValue
                            myFinancial.currentAssets = deeper.1["currentAssets"].stringValue
                            myFinancial.currentCash = deeper.1["currentCash"].stringValue
                            myFinancial.currentDebt = deeper.1["currentDebt"].stringValue
                            myFinancial.grossProfit = deeper.1["grossProfit"].stringValue
                            myFinancial.netIncome = deeper.1["netIncome"].stringValue
                            myFinancial.operatingexpense = deeper.1["operatingexpense"].stringValue
                            myFinancial.operatingGainsLosses = deeper.1["operatingGainsLosses"].stringValue
                            myFinancial.operatingIncome = deeper.1["operatingIncome"].stringValue
                            myFinancial.operatingRevenue = deeper.1["operatingRevenue"].stringValue
                            myFinancial.reportDate = deeper.1["reportDate"].stringValue
                            myFinancial.researchAndDevlopment = deeper.1["researchAndDevlopment"].stringValue
                            myFinancial.shareholderEquity = deeper.1["shareholderEquity"].stringValue
                            myFinancial.totalAssets = deeper.1["totalAssets"].stringValue
                            myFinancial.totalDebt = deeper.1["totalDebt"].stringValue
                            myFinancial.totalLiabilities = deeper.1["totalLiabilities"].stringValue
                            myFinancial.totalRevenue = deeper.1["totalRevenue"].stringValue
                            
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
                userSelectedStock.append(myStocks)
                SVProgressHUD.dismiss()
            }
        }
        
        
        titleCompanyNameOutlet.text = data?.companyName
        titlePriceAndChangeOutlet.text = "\(String(describing: data?.latestPrice ?? "No data Available"))  \(data?.change ?? "")  \(String(describing: data?.change ?? "No data Available"))"
        
     //   downloadPictures(locationString: data?.logo ?? "No Logo Available")
        
        data = userSelectedStockTwo
        
        //setupEarnings()
       // setupFinancial()
        buildCharts()
        
        addMissingData()
        
        SVProgressHUD.dismiss()
        
        earningsTableviewOutlet.reloadData()
        financialTableviewOutlet.reloadData()
        detailsTableViewOutlet.reloadData()
    
    }
    
                //setup pie charts
    func setupPieChart(){
       
        /*
        pieChartOutlet.noDataText = "No Data Available"
        var barDataEntries: [BarChartDataEntry] = []
        var myCustomData = [Double]()
        
        if let myChartData = data?.chartsData{
            for each in myChartData{
                myCustomData.append(Double(each.open ?? 1.0))
            }
        }
        let count = myCustomData.count
        
        let barChartDataSet = LineChartDataSet(values: <#T##[ChartDataEntry]?#>, label: <#T##String?#>)
        
      //  pieChartOutlet.data = chartData
      //  pieChartOutlet.notifyDataSetChanged()
 
         */
    }
    
    /*Charts and more

     var dataEntries: [BarChartDataEntry] = []
     let count = data?.charts.count

     for i in 0..<count! {
     let dataEntry = BarChartDataEntry(x: dataPoints[i], y: Double(i))
     dataEntries.append(dataEntry)
     }
     
     let chartDataSet = BarChartDataSet(values: dataEntries, label: "testing")
     let chartData = BarChartData(dataSet: chartDataSet)
     myChart.data = chartData
     
     }
     
     func setupPieChart(){
     var myDataEntryArray = [PieChartDataEntry]()
     
     let entry1 = PieChartDataEntry(value: Double(34), label: "#1")
     let entry2 = PieChartDataEntry(value: Double(64), label: "#2")
     let entry3 = PieChartDataEntry(value: Double(94), label: "#3")
     
     let dataSet = PieChartDataSet(values: [entry1,entry2,entry3], label: "Widgets and more")
     let data = PieChartData(dataSet: dataSet)
     
     for each in myPieData{
     var entry = PieChartDataEntry(value: each, label: "\(each)")
     myDataEntryArray.append(entry)
     }
     
     let myDataSet = PieChartDataSet(values: myDataEntryArray, label: "using Loop")
     let newData = PieChartData(dataSet: myDataSet)
     // myPieChart.data = data
     myPieChart.data = newData
     // used to kick things into gear like table.reload()
     myPieChart.notifyDataSetChanged()
     }
     
    */
    
    func adsSetup() {
        lastGoogleAd.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        lastGoogleAd.rootViewController = self
        lastGoogleAd.load(GADRequest())
        

        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSetup()
        viewSetup()
        
        if let testForBitCion = data?.sector {
            if testForBitCion == "cryptocurrency"{
                
            }else{
                buildCharts()
            } 
            
        }
        
        
        
        collectionViewOutlet.reloadData()
        
    }

}


