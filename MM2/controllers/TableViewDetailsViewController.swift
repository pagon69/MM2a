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

class TableViewDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //table view cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableViewOutlet.dequeueReusableCell(withIdentifier: "detailsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = myNamesArray[indexPath.row]
        cell.detailTextLabel?.text = myArray[indexPath.row]
        
        return cell
    }
    

    
    
    //gloabals
    var data: Stock?
    
    //use a dictionary for this part versus two arrays
    var myArray = [String]()
    var myNamesArray = ["High","52 Week High","Low","52 Week Low","Change"]
    var changeIconUp = "🔺"
    var changeIconDown = "🔻"
    
    
    
    //outlets
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var detailsTableViewOutlet: UITableView!
    
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
        
        var change = ""
        
        //sets up the various views along with the segment controls
        self.newsOutlet.isHidden = true
        self.financialOutlet.isHidden = true
        self.detailsOutlet.isHidden = false
        self.earningOutlet.isHidden = true
        
        //setup the tableview
        myArray.append(data?.high ?? "No Current Value")
        myArray.append(data?.week52High ?? "No Current Value")
        myArray.append(data?.low ?? "No Current Value")
        myArray.append(data?.week52Low ?? "No Current Value")
        myArray.append(data?.change ?? "No Current Value")
        
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
    
    
    func buildGraphs() {
        
        print("creating graphs")
        
    }
    
    /*Charts and more
    func setCharts(dataPoints: [Double]){
        myChart.noDataText = "No data available"
        
        let months = ["j","f","m","a","m","j","j","a","s"]
        
        var dataEntries: [BarChartDataEntry] = []
        
        let count = data?.charts.count
        
        print(count)
        
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        buildGraphs()
        adsSetup()
        
        print(data?.companyName ?? "Nothing sent")
        print(data?.latestPrice ?? "Nothing sent")
        
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
