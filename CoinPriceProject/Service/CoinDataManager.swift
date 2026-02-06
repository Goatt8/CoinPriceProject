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
        }
    }
}
