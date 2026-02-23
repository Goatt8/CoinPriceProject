//
//  CoinDisplayModel.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import Foundation

struct CoinModel: Equatable {
    let market: String      // KRW-BTC
    let koreanName: String  // 비트코인
    let symbol: String      // BTC
    var price: String
    var changeRate: String
    var changeStatus: String
    var changedPrice: String
    var volume: Double
    let logoURL: URL?
}
