//
//  Stock.swift
//  MM2
//
//  Created by user147645 on 3/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class Stock {
    
    var symbol: String?
    var companyName: String?
    var primaryExchange: String?
    var sector: String?
    var calculationPrice: String?
    var open: String?
    var openTime: String?
    var close: String?
    var closeTime: String?
    var high: String?
    var low: String?
    var latestPrice: String?
    var latestSource: String?
    var latestTime: String?
    var latestUpdate: String?
    var latestVolume: String?
    var iexRealTimePrice: String?
    var ieRealtimeSize: String?
    var iexLastUpdated: String?
    var delayedPrice: String?
    var delayedPriceTime: String?
    var extendedPrice: String?
    var extendedChange: String?
    var extendedChangePercent: String?
    var extendedPriceTime: String?
    var previousClose: String?
    var change: String?
    var changePercent: String?
    var iexMarketPercent: String?
    var iexVolume: String?
    var avgTotalVolume: String?
    var iexBidPrice: String?
    var iexBidSize: String?
    var iexAskPrice: String?
    var iexAskSize: String?
    var marketCap: String?
    var peRation: String?
    var week52High: String?
    var week52Low: String?
    var ytdChange: String?
    
    var newsData = [String]()
    var chartsData = [Chart]()
    var financialData = [String]()
    var earningsData = [String]()
    
}
