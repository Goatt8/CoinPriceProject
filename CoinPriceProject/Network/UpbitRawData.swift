//
//  CoinModel.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import Foundation

struct UpbitRawData: Decodable {
    let market: String
    let tradePrice: Double
    let change: String
    let changeRate: Double
    let accTradePrice24h: Double
    
    enum CodingKeys: String, CodingKey {
        case market
        case tradePrice = "trade_price"
        case change
        case changeRate = "change_rate"
        case accTradePrice24h = "acc_trade_price_24h"
    }
}



