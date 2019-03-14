//
//  MarketViewController.swift
//  MM2
//
//  Created by user147645 on 3/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class MarketViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //Table view stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text = searchResults?[indexPath.row].Description
        cell.detailTextLabel?.text = searchResults?[indexPath.row].Symbol
        
        return cell
    }
    

    //my global variables
    
    let myArray = ["car","boat","house","mace","gun","door","banana"]
    var searchResults :Results<Symbols>?
    
    var timing = 0
    var myTimer = Timer()
    
    var myRealm = try! Realm()
    
    var lastTicker = CGFloat()
    var currentIndexPath = 0
    var userInput = ""
    var searchR = [String]()
    
    
    
    
    //my functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
        print("user typed \(userInput)")
    }
    
    func doSearch( searchV : String ){
        searchR = myArray.filter({ (item) -> Bool in
            item.lowercased().contains(searchV)
        })

        //  print("The value sent is: \(searchValue) and the results is : \(searchR)")
        
        var ‌‌sortedSearch = searchR.sorted()
        
        /*
         searchR = myArray.filter({ item in
         return item.lowercased().contains(searchText)
         })
         */
        //let searchValue = searchV
        
        let items = myRealm.objects(Symbols.self).filter("Description CONTAINS[cd] %@", searchV).sorted(byKeyPath: "Description", ascending: true)
        
        searchResults = items
        //print("from my realm: \(items)")
    }
    
    
    func openRealm() {
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
        let bundleRealmPath = Bundle.main.url(forResource: "symbols", withExtension: "realm")
        
        if FileManager.default.fileExists(atPath: defaultRealmPath.absoluteString) {
            
            do{
                try FileManager.default.removeItem(at: defaultRealmPath)
                
                print("deleted the default realm")
                
            }catch {
                
                print("could not delete the default realm")
                
            }
            do {
                try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
                print("coping the files")
            }catch let error {
                print("error copying seed files: \(error)")
            }
        }
    }
    
    // start of all runtime stuff
    override func viewDidLoad() {
        super.viewDidLoad()

        openRealm()
        
        //realsm configuration stuff
        let bundleRealmPath = Bundle.main.url(forResource: "symbols", withExtension: "realm")
        let config = Realm.Configuration(fileURL: bundleRealmPath,
                                         readOnly: false,
                                         schemaVersion: 10,
                                         migrationBlock:
            { migration, oldSchemaVersion in
                
                if(oldSchemaVersion < 1){
                    print("do nothing")
                }
        })
        
        let realm = try! Realm(configuration: config)
        myRealm = try! Realm(configuration: config)
        
        
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
