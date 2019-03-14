//
//  Markets.swift
//  MM2
//
//  Created by user147645 on 3/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class Markets {
    
    var mic: String
    var tapeId: String
    var venueName: String
    var volume: String
    var marketPercent: String
    var charts: [Double]
    var tapeA: String
    var tapeB: String
    var tapeC: String
    var lastUpdated: String
    
    init(mic: String,tapeId: String, venueName: String, volume: String, marketPercent: String, charts: [Double], tapeA: String, tapeB: String, tapeC: String, lastUpdated: String) {
        
        self.mic = mic
        self.tapeId = tapeId
        self.marketPercent = marketPercent
        self.venueName = venueName
        self.volume = volume
        self.charts = charts
        self.tapeA = tapeA
        self.tapeB = tapeB
        self.tapeC = tapeC
        self.lastUpdated = lastUpdated
    
    }
    
}
