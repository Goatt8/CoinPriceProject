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
    
    // CoinViewModel.swift
    private func setupSearchPipeline() {
        // CombineLatest 대신 직접 구독해서 filteredCoins에 꽂아버리기
        CoinDataManager.shared.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allCoins in
                let text = self?.searchText ?? ""
                if text.isEmpty {
                    self?.filteredCoins = allCoins
                } else {
                    self?.filteredCoins = allCoins.filter {
                        $0.koreanName.contains(text) || $0.symbol.contains(text.uppercased())
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func updateTicker() {
        CoinDataManager.shared.fetchTickerData()
    }
    
}
