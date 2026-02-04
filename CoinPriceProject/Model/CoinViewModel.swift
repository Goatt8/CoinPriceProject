//
//  CoinViewModel.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import UIKit

class CoinViewModel {
    var coinList: [CoinModel] = []
    
    private var marketDicts: [String: String] = [:]
    
    var onUpdated: (() -> Void)?
    
    private let testMarketDict = [
        "KRW-BTC": "비트코인",
        "KRW-ETH": "이더리움",
        "KRW-XRP": "리플",
        "KRW-SOL": "솔라나"
    ]
    
    func fetchTickerData() {
        if marketDicts.isEmpty {
            NetworkService.shared.fetchMarketList { [weak self] result in
                switch result {
                case .success(let marketCodes):
                    // KRW -
                    let krwMarkets = marketCodes.filter { $0.market.hasPrefix("KRW-") }
                    // marketDics[Key] = Value
                    krwMarkets.forEach { self?.marketDicts[$0.market] = $0.koreanName }
                    
                    self?.updateTickerData()
                    
                case .failure(let error):
                    print("마켓 리스트 가져오기 실패: \(error)")
                }
            }
        } else {
            updateTickerData()
        }
    }
    
    private func updateTickerData() {
        let markets = marketDicts.keys.joined(separator: ",")
        
        NetworkService.shared.fetchUpbiteData(markets: markets) { [weak self] result in
            switch result {
            case .success(let rawData):
                //UpbitRaw -> CoinModel
                self?.convert(from: rawData)
                
            case .failure(let error):
                print("fetchCoins Error: \(error)")
            }
        }
    }
    
    private func convert(from rawList: [UpbitRawData]) {
        
        print("가공 전 원본 데이터 개수: \(rawList.count)")
        
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
            self.coinList = converted
            self.onUpdated?()
        }
    }
}
