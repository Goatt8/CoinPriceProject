//
//  FavoriteManager.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import Foundation
import Combine

class FavoriteManager {
    static let shared = FavoriteManager()
    private init() {}

    @Published private(set) var favoriteMarkets: Set<String> = []

    func toggleFavorite(market: String) {
        if favoriteMarkets.contains(market) {
            favoriteMarkets.remove(market)
        } else {
            favoriteMarkets.insert(market)
        }
    }
    
    func isFavorite(market: String) -> Bool {
        return favoriteMarkets.contains(market)
    }
}
