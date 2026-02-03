//
//  CoinDisplayModel.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import Foundation

struct CoinModel {
    let market: String      // KRW-BTC
    let koreanName: String  // 비트코인
    let symbol: String      // BTC
    let price: String
    let changeRate: String
    let changeStatus: String
    let changedPrice: String
    let volume: Double
    let logoURL: URL?
}
