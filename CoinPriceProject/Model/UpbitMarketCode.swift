//
//  UpbitModel.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import Foundation

struct UpbitMarketCode: Codable {
    let market: String
    let koreanName: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
    }
}
