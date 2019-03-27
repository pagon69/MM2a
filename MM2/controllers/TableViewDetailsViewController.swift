//
//  TableViewDetailsViewController.swift
//  MM2
//
//  Created by user147645 on 3/27/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class TableViewDetailsViewController: UIViewController {

    //gloabals
    var data: Markets?
    
    
    //outlets
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToSearch2", sender: self)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
