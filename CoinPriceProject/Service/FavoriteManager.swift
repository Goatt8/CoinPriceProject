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
    private let favoritesKey = "favoriteMarkets"
    
    @Published var favoriteMarkets: Set<String> = [] {
        didSet {
            saveFavorites()
        }
    }
    
    private init() {
        loadFavorites()
    }
    
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
    
    //userDefaults에서 불러오기
    private func loadFavorites() {
        if let savedArray = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            self.favoriteMarkets = Set(savedArray)
        }
    }
    
    //userDefaults에 저장
    private func saveFavorites() {
        let array = Array(favoriteMarkets)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }
}
