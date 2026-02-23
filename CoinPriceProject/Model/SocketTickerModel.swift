//
//  SocketTickerModel.swift
//  CoinPriceProject
//
//  Created by goat on 2/20/26.
//

import Foundation

struct SocketTickerModel: Codable {
    let code: String?
    let tradePrice: Double?
    let change: String?
    let signedChangeRate: Double?
    let signedChangePrice: Double?
    let accTradePrice24h: Double

    enum CodingKeys: String, CodingKey {
        case code
        case tradePrice = "trade_price"
        case change
        case signedChangeRate = "signed_change_rate"
        case signedChangePrice = "signed_change_price"
        case accTradePrice24h = "acc_trade_price_24h"
    }
}
