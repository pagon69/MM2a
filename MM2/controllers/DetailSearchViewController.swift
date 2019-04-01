//
//  DetailSearchViewController.swift
//  MM2
//
//  Created by user147645 on 3/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class DetailSearchViewController: UIViewController {

    
    var data: Markets?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(data?.venueName ?? "nothing sent")
        print(data?.marketPercent ?? "nothing sent")
        print(data?.volume ?? "nothing sent")
        
        
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
