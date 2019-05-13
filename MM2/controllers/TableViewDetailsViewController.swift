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

class TableViewDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    
    //remove after this works
   let my2Array = ["Apple","Corn","fox","box","tennis"]
    
    let myTextArray = "This is random text which will go within the text view editor as a way to test if this code is working correctly"
    
    /*
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data?.newsData.count ?? 1
    }
    */
    
    //collectionView setup
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return myArray.count
        //print("how many items in this data:\(data?.newsData.count ?? 1)")
        return my2Array.count
        //return data?.newsData.count ?? 1
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewOutlet.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! NewsCell
        
        cell.backgroundColor = UIColor.lightGray
        /*
        cell.titleOutlet.text = data?.newsData[indexPath.section].headline
        cell.referencesOutlet.text = "Date:\(String(describing: data?.newsData[indexPath.row].datetime ?? "Nope")), Source:\(String(describing: data?.newsData[indexPath.row].source ?? "Nothing")), Related:\(String(describing: data?.newsData[indexPath.row].related ?? "what now"))"
        
        cell.summaryOutlet.text = data?.newsData[indexPath.section].summary
       */
        cell.titleOutlet.text = my2Array[indexPath.row]
        cell.summaryOutlet.text = myTextArray
        cell.referencesOutlet.text = my2Array[indexPath.row]
        
        //can i add this someplace?
       // cell.cellURL.text = data?.newsData[indexPath.row].url
        
        //need to call a image download when this happens
    
        cell.newsImageOutlet.image = downloadNewsPictures(locationString: data?.newsData[indexPath.row].image ?? " No Logo Available")
        
        return cell
    }
 
    
    //table view cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if(tableView.tag == 0){
           count = myNamesArray.count        }
        
        if(tableView.tag == 1){
            
            count = myNamesArray.count        }
        
        if(tableView.tag == 2){
            count = myNamesArray.count
            
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let myFinancialData: [String] = []
        
        /*
        for 0..<(data?.financialData.count ?? 1){
                myFinancialData.append(data?.financialData)
        }
        */
        
        var cell = UITableViewCell()
        
        //details tableview
        if(tableView.tag == 0){
        cell = detailsTableViewOutlet.dequeueReusableCell(withIdentifier: "detailsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = myNamesArray[indexPath.row]
        cell.detailTextLabel?.text = myDetailsArray[indexPath.row]
        }
        //earnings tableview
        if(tableView.tag == 1){
            cell = earningsTableviewOutlet.dequeueReusableCell(withIdentifier: "earningsCell", for: indexPath)
            
            cell.textLabel?.text = myNamesArray[indexPath.row]
            cell.detailTextLabel?.text = myDetailsArray[indexPath.row]
        }
        //financial tableview
        if(tableView.tag == 2){
            cell = financialTableviewOutlet.dequeueReusableCell(withIdentifier: "financialCell", for: indexPath)
            
            cell.textLabel?.text = myNamesArray[indexPath.row]
            cell.detailTextLabel?.text = myDetailsArray[indexPath.row]
            
        }
        
            
        return cell
    }
    

    
    
    //gloabals
    var data: Stock?
    var data2: String?
    
    //use a dictionary for this part versus two arrays
    var myArray = [String]()
    
    var myDetailsArray = [String]()
    
    let myNamesArray = ["Symbol","Company Name","Sector","Primary Exchange","Calculation price","Open","Close","High","52 Week High","Low","52 Week Low","Previous Close","Lastest price","Latest Source","Latest Volume","IEX RealTimePrice","IEX RealTimeSize","Delayed Price","extended Price","extended Change","extended change percent","change", "change percent","IEX Market Percent", "IEX Volume", "Avg Total Volume", "IEX Bid Price","IEX Ask Price","IEX Ask Size","Market cap","Pe Ratio","YTD Change"  ]
    var changeIconUp = "🔺"
    var changeIconDown = "🔻"
    let financialNames = ["report Date","Gross Profit","Cost of revenue","Operating Revenue","Total Revenue","Operating Income","Net Income","Research and Development","Operating Expense","Current Assets","Total Assets","Total Liabilities","Current Cash","Current Debt","Total Cash","Total debt","ShareHolder Equity","Cash Change", "Cash Flow","Operating Gains and Losses"]
    
    var watchListItems = [String]()
    let myDefaults = UserDefaults.standard
    
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
    @IBOutlet weak var googleAdoutlet: GADBannerView!
    @IBOutlet weak var earningsAdOutlet: GADBannerView!
    @IBOutlet weak var financailADOutlet: GADBannerView!
    @IBOutlet weak var newsAdOutlet: GADBannerView!
    
    
    
    
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
        
        //setup the tableview
        //myArray.append(data?.high ?? "No Current Value")
        //myArray.append(data?.week52High ?? "No Current Value")
       // myArray.append(data?.low ?? "No Current Value")
        //myArray.append(data?.week52Low ?? "No Current Value")
        //myArray.append(data?.change ?? "No Current Value")
        
        //sets up detials view
        setupDetailsView()
        
        /*updating the TitleView and data
        if(Int(data?.change ?? "1")! > 0){
            change = changeIconUp
        }else{
            change = changeIconDown
        }
        */
        
        titleCompanyNameOutlet.text = data?.companyName
        titlePriceAndChangeOutlet.text = "\(String(describing: data?.latestPrice ?? "No data Available"))  \(change)  \(String(describing: data?.change ?? "No data Available"))"
        
        downloadPictures(locationString: data?.logo ?? "No Logo Available")
        detailsTableViewOutlet.reloadData()
        
       // collectionViewOutlet.reloadData()
    }
    
    func setupDetailsView(){
        
        //setup the tableview
        /*ol","Company Name","Sector","Primary Exchange","Calculation price","Open","Close","High","52 Week High","Low","52 Week Low","Change","Lastest price","Latest Source","Latest Volume","IEX RealTimePrice","IEX RealTimeSize","Delayed Price","extended Price","extended Change","extended change percent","change", "change percent","IEX Market Percent", "IEX Volume", "Avg Total Volume", "IEX Bid Price","IEX Ask Price","IEX Ask Size","Market cap","Pe Ratio","YTD Change"  ]
        */
        
        myDetailsArray.append(data?.symbol ?? "No Current Value")
        myDetailsArray.append(data?.companyName ?? "No Current Value")
        myDetailsArray.append(data?.sector ?? "No Current Value")
        myDetailsArray.append(data?.primaryExchange ?? "No Current Value")
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
    
    
    func buildCharts() {
        combinedChartsOutlet.noDataText = "No Data Available"
        
        var barDataEntries: [BarChartDataEntry] = []
       // let lineDataEntries: [LineChartData] = []
        let count = data?.chartsData.count ?? 1
        var myDataArray: [Double] = []
        // removes optionals from my data
        for i in 0..<count{
            if let myData = data?.chartsData[i].low{
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
    }
    
    func setupPieChart(){
        pieChartOutlet.noDataText = "No Data Available"
        var pieDataEntries: [PieChartDataEntry] = []
        //var pieDataEntries: [PieChartDataEntry]?
        
        // let lineDataEntries: [LineChartData] = []
        let count = data?.earningsData.count ?? 1
        var myDataArray: [Double] = []
        
        // removes optionals from my data
        for i in 0..<count{
            if let myData = data?.earningsData[i].actualEPS{
                myDataArray.append(myData)
            }
        }
        for i in 0..<count{
            let pieDataEntry = PieChartDataEntry(value: myDataArray[i], label: data?.earningsData[i].fiscalPeriod)
            pieDataEntries.append(pieDataEntry)
        }
        let chartDataSet = PieChartDataSet(values: pieDataEntries, label: "ActualEPS by Quarter")
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartOutlet.data = chartData
        pieChartOutlet.notifyDataSetChanged()
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
        googleAdoutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAdoutlet.rootViewController = self
        googleAdoutlet.load(GADRequest())
        
        earningsAdOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
       earningsAdOutlet.rootViewController = self
        earningsAdOutlet.load(GADRequest())
        
        financailADOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        financailADOutlet.rootViewController = self
        financailADOutlet.load(GADRequest())
        
        
        newsAdOutlet.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        newsAdOutlet.rootViewController = self
        newsAdOutlet.load(GADRequest())
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        adsSetup()
       
        viewSetup()
        
        buildCharts()
        
        collectionViewOutlet.reloadData()
        
    }

}


