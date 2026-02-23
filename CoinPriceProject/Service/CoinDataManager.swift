//
//  CoinDataManager.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import Foundation
import Combine

class CoinDataManager {
    static let shared = CoinDataManager()
    private init() {}
    
    @Published var allCoins: [CoinModel] = []

    private var marketDicts: [String: String] = [:]
    
    func fetchTickerData() {
        guard marketDicts.isEmpty else {
            updateTickerData()
            return
        }
        NetworkService.shared.fetchMarketList { [weak self] result in
            switch result {
            case .success(let marketCodes):
                // KRW - 필터
                let krwMarkets = marketCodes.filter { $0.market.hasPrefix("KRW-") }
                // marketDics[Key] = Value
                krwMarkets.forEach { self?.marketDicts[$0.market] = $0.koreanName }
                self?.updateTickerData()
                
            case .failure(let error):
                print("fetchTickerData 실패 \(error)")
            }
        }
    }
    
    //convert - UpbitRaw -> CoinModel
    private func updateTickerData() {
        let markets = marketDicts.keys.joined(separator: ",")
        
        NetworkService.shared.fetchUpbiteData(markets: markets) { [weak self] result in
            switch result {
            case .success(let rawData):
                //UpbitRaw -> CoinModel
                self?.convert(from: rawData)
                
            case .failure(let error):
                print("fetchCoins 실패 \(error)")
            }
        }
    }
    
    private func convert(from rawList: [UpbitRawData]) {
        
        print("convert: rawData 갯수 \(rawList.count)")
        var converted = rawList.compactMap { raw -> CoinModel? in
            let symbol = raw.market.split(separator: "-").last.map(String.init) ?? ""
            return CoinModel(
                market: raw.market,
                koreanName: marketDicts[raw.market] ?? "Unknown",
                symbol: symbol,
                price: raw.tradePrice.formattedThousandNumComma,
                changeRate: String(format: "%.2f%%", raw.changeRate * 100),
                changeStatus: raw.change,
                changedPrice: raw.signedChangePrice.formattedThousandNumComma,
                volume: raw.accTradePrice24h,
                logoURL: URL(string: "https://static.upbit.com/logos/\(symbol).png")
            )
        }
        converted.sort { $0.volume > $1.volume }
    
        DispatchQueue.main.async {
            self.allCoins = converted
            
            SocketManager.shared.connect()
        }
    }
    
    func updateRealTimePrice(with socketData: SocketTickerModel) {
        guard let marketCode = socketData.code,
              let rawPrice = socketData.tradePrice, rawPrice > 0 else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 현재 배열(allCoins)에서 해당 코인의 위치(index)를 찾음
            if let index = self.allCoins.firstIndex(where: { $0.market == marketCode }) {
                
                var updatedCoin = self.allCoins[index]
                
                updatedCoin.price = rawPrice.toCurrencyString()
            
                if let change = socketData.change {
                    updatedCoin.changeStatus = change
                }
                
                if let rate = socketData.signedChangeRate {
                    updatedCoin.changeRate = rate.toPercentageString()
                }
                
                if let changePrice = socketData.signedChangePrice {
                    updatedCoin.changedPrice = changePrice.toCurrencyString()
                }
            
                let tradeAmount = socketData.accTradePrice24h
                    updatedCoin.volume = tradeAmount
                
                self.allCoins[index] = updatedCoin
                
                //test
                if marketCode == "KRW-BTC" {
                    print("✅ 비트코인 price: \(updatedCoin.price)")
                }
            }
        }
    }
    
}
