//
//  IPODetailsViewController.swift
//  MM2
//
//  Created by Andy Alleyne on 5/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class IPODetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ipoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ipotableview.dequeueReusableCell(withIdentifier: "ipoCell", for: indexPath)
        
        cell.textLabel?.text = ipoNames[indexPath.row]
        cell.detailTextLabel?.text = ipoFiltereddata[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var heading: String = ""
        
        if(tableView.tag == 0){
            heading = "\(String(describing: data?.companyName ?? ""))'s IPO Details:"
        }
        
        return heading
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.black
        //view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //globals
    var data : IPO?
    var myIPO = [IPO]()
    
    
    var ipoNames = ["Company name","Symbol","Expected Date","Auditor","Market","Employees","URL","Status","Shares Offered","Low Price", "High Price","Offer Amount","Total Expenses","Share Over Alloted","Share Holder Shares","Shares Outstanding","Lockup Period Expiration","Quiet Period Expiration","Revenue","Net Income","Total Assets","Total Liabilities","Stock Holder Equity","Competition","Amount","Percent Offered"]
    
    var ipoFiltereddata = [String]()
    
    @IBOutlet weak var ipotableview: UITableView!
    @IBOutlet weak var textViewOutlet: UITextView!
    
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSearch7", sender: self)
        
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func setupView(){
        //I have to create strings and put it all together
        
        textViewOutlet.text = "\(String(describing: data?.companyName ?? ""))\n\(String(describing: data?.ceo ?? ""))\n\(String(describing: data?.address ?? ""))\n\(String(describing: data?.city ?? "")), \(String(describing: data?.state ?? "")), \(String(describing: data?.zip ??  ""))\nPhone # \(String(describing: data?.phone ?? ""))"
        
        textViewOutlet.text.append("\n\nCompany Consul:\n")
        
        for each in data?.companyCounsel ?? ["No Company consul found"]{
            textViewOutlet.text.append("\(each)\n")
        }
        
        textViewOutlet.text.append("\nLead Underwriters:\n")
        
        for each in data?.leadUnderwriters ?? ["No listed underwritters"]{
            textViewOutlet.text.append("\(each)\n")
        }
        
        textViewOutlet.text.append("\nUser Writters:\n")
        
        for each in data?.underwriters ?? ["No under writters found"]{
            textViewOutlet.text.append("\(each)\n")
        }
        
        textViewOutlet.text.append("\n\nCompany Description:\n\(String(describing: data?.companyDescription ?? ""))\n\nBusiness Description:\n\(String(describing: data?.businessDescription ?? ""))\n\nUse of proceeds:\n\(String(describing: data?.useOfProceeds ?? ""))")
        
 
        ipoFiltereddata.append(data?.companyName ?? "")
        ipoFiltereddata.append(data?.symbol ?? "")
        ipoFiltereddata.append(data?.expectedDate ?? "")
        ipoFiltereddata.append(data?.auditor ?? "")
        ipoFiltereddata.append(data?.market ?? "")
        ipoFiltereddata.append(data?.employees ?? "")
        ipoFiltereddata.append(data?.url ?? "")
        ipoFiltereddata.append(data?.status ?? "")
        ipoFiltereddata.append(data?.sharesOffered ?? "")
        ipoFiltereddata.append(data?.priceLow ?? "")
        ipoFiltereddata.append(data?.priceHigh ?? "")
        ipoFiltereddata.append(data?.offerAmount ?? "")
        ipoFiltereddata.append(data?.totalExpenses ?? "")
        ipoFiltereddata.append(data?.sharesOverAlloted ?? "")
        ipoFiltereddata.append(data?.shareholderShares ?? "")
        ipoFiltereddata.append(data?.sharesOutstanding ?? "")
        ipoFiltereddata.append(data?.lockupPeriodExpiration ?? "")
        ipoFiltereddata.append(data?.quietPeriodExpiration ?? "")
        ipoFiltereddata.append(data?.revenue ?? "")
        ipoFiltereddata.append(data?.netIncome ?? "")
        ipoFiltereddata.append(data?.totalAssets ?? "")
        ipoFiltereddata.append(data?.totalLiabilities ?? "")
        ipoFiltereddata.append(data?.stockholderEquity ?? "")
        ipoFiltereddata.append(data?.competition ?? "")
        ipoFiltereddata.append(data?.amount ?? "")
        ipoFiltereddata.append(data?.percentOffered ?? "")
        
        ipotableview.reloadData()
    }
    
    
    
    
    
    
//view is loaded at this point
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
        
        
        
        // Do any additional setup after loading the view.
    }
    
//end of function
}
