//
//  DisclaimersViewController.swift
//  MM2
//
//  Created by user147645 on 4/17/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import GoogleMobileAds


class DisclaimersViewController: UIViewController {

    
    
    
    //outlets
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var googleAds: GADBannerView!
    
    @IBOutlet weak var disclaimertextField: UITextView!
    
    
    //global data
    
    var privacyData = "We do not sell or do anything with your data. We currently collect no data and only provide generic ADs to avoid collecting and setting data to anyone for add money."
    var attributionData = "Data provided for free by IEX. View IEX’s Terms of Use.(https://iextrading.com/api-exhibit-a/"
    var securityData = "We are as secure as can be expected."
    var teamData = "Application created by Alleyne Ventures, visit our blog for details or to questions and provide feedback.\nEmail:pagon69@hotmail.com with any bugs or issues or comments."
    var podsUsed = "I would like the following teams for great code bases and pods which were used in some way.\n1. AlamoFire - networking made simple.\n2.AlamofireImage = makes async calls and image processing eaiser.\n3.SwiftyJSON = helps make json processing so much easier.\n4.RealmSwift = new DB technology is amazing.\n5.SVProgressHUD = makings having process bars easier.\n6.Google Ad Mob for ads and monitization."
    
    
    func viewSetup(){
        disclaimertextField.text = "Privacy disclaimer: \n\(privacyData)\n\n Attribution:\(attributionData)\n\nSecurity disclaimer:\n\(securityData)\n\nTeam WebSite:\n\(teamData)"
    }
    
    
    func adsSetup() {
        googleAds.adUnitID = "ca-app-pub-7563192023707820/2466331764"
        googleAds.rootViewController = self
        googleAds.load(GADRequest())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        adsSetup()
        viewSetup()
        
        // Do any additional setup after loading the view.
    }

}
