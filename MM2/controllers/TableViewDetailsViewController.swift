//
//  TableViewDetailsViewController.swift
//  MM2
//
//  Created by user147645 on 3/27/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

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
    
    
    
    
    
    //outlets
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var detailsTableViewOutlet: UITableView!
    
    @IBOutlet weak var earningOutlet: UIView!
    @IBOutlet weak var detailsOutlet: UIView!
    @IBOutlet weak var financialOutlet: UIView!
    @IBOutlet weak var newsOutlet: UIView!
    @IBOutlet weak var viewControlsOutlet: UISegmentedControl!
    
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
        self.newsOutlet.isHidden = true
        self.financialOutlet.isHidden = true
        self.detailsOutlet.isHidden = false
        self.earningOutlet.isHidden = true
        
        myArray.append(data?.high ?? "No Current Value")
        myArray.append(data?.week52High ?? "No Current Value")
        myArray.append(data?.low ?? "No Current Value")
        myArray.append(data?.week52Low ?? "No Current Value")
        myArray.append(data?.change ?? "No Current Value")
        
        detailsTableViewOutlet.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        
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
