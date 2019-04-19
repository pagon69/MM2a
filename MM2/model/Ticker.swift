//
//  Ticker.swift
//  MM2
//
//  Created by user147645 on 4/19/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class Ticker {
    
    var name: String
    var price: String
    var change : String
    var picture : String
    
    init(name: String, price: String, change: String, picture : String) {
        self.name = name
        self.price = price
        self.change = change
        self.picture = picture
    }
    
    
}
