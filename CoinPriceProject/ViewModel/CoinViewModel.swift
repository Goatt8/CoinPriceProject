//
//  CoinViewModel.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import UIKit
import Combine

class CoinViewModel {
    
    @Published var searchText: String = ""
    
    @Published var filteredCoins: [CoinModel] = []
    
    private var marketDicts: [String: String] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchPipeline()
    }
    
    private func setupSearchPipeline() {
        Publishers.CombineLatest(CoinDataManager.shared.$allCoins, $searchText)
            .map { (allCoins, text) in
                if text.isEmpty { return allCoins }
                return allCoins.filter { $0.koreanName.contains(text) || $0.symbol.contains(text.uppercased()) }
            }
            .assign(to: &$filteredCoins)
    }
    
    func updateTicker() {
        CoinDataManager.shared.fetchTickerData()
    }
    
}
