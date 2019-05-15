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
        cell.detailTextLabel?.text = "$50.32"
        

        
        return cell
    }
    
    
    //globals
    var data : IPO?
    var myIPO = [IPO]()
    
    
    var ipoNames = ["Symbol","Company name","Expected Date","Auditor","Market","CIK","Address","State","City","Zip","Phone","CEO","Employees","URL","Status","Shares Offered","Low Price", "High Price","Offer Amount","Total Expenses","Share OverAlloted","Share Holder Shares","Shares Outstanding","Lockup Period Expiration","Quiet Period Expiration","Revenue","Net Income","Total Assets","Total Liabilities","Stock Holder Equity","company Description","Business Description","Use of proceeds","Competition","Amount","Percent Offered"]
    
    
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
        
        textViewOutlet.text = "\n\nCompany Description:\n\(String(describing: data?.companyDescription ?? ""))\n\nBusiness Description:\n\(String(describing: data?.businessDescription ?? ""))\n\nUse of proceeds:\n\(String(describing: data?.useOfProceeds ?? ""))"
        
        textViewOutlet.text.append("\nCompany Consul:\n")
        
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
        
    }
    
    
    
    
    
    
//view is loaded at this point
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
        
        
        
        // Do any additional setup after loading the view.
    }
    
//end of function
}
