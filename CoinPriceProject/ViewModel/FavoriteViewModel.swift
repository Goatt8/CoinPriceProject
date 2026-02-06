//
//  FavoriteViewModel.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import UIKit
import Combine

class FavoriteViewModel {
    
    @Published var favoriteCoins: [CoinModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
            setupFavoritePipeline()
        }
    
    private var marketDicts: [String: String] = [:]
    
    // MARK: - Combine - 전체 코인리스트 + favorite코인리스트
    private func setupFavoritePipeline() {
            Publishers.CombineLatest(
                CoinDataManager.shared.$allCoins,
                FavoriteManager.shared.$favoriteMarkets
            )
            .map { (allCoins, favorites) in
                return allCoins.filter { favorites.contains($0.market) }
            }
            .assign(to: &$favoriteCoins)
        }
    
}
