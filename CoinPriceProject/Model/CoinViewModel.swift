//
//  CoinViewModel.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import UIKit

class CoinViewModel {
    var coinList: [CoinModel] = []
    
    var onUpdated: (() -> Void)?
    
    private let testMarketDict = [
        "KRW-BTC": "비트코인",
        "KRW-ETH": "이더리움",
        "KRW-XRP": "리플",
        "KRW-SOL": "솔라나"
    ]

    func fetchCoins() {
        // "KRW-BTC,KRW-ETH"
        let markets = testMarketDict.keys.joined(separator: ",")
        
        NetworkService.shared.fetchUpbiteData(markets: markets) { [weak self] result in
            switch result {
            case .success(let rawData):
                self?.convert(from: rawData)
                print("데이터 변환 완료! 개수: \(self?.coinList.count ?? 0)")

            case .failure(let error):
                print("fetchCoins Error: \(error)")
            }
        }
    }
    
    private func convert(from rawList: [UpbitRawData]) {
        
        print("가공 전 원본 데이터 개수: \(rawList.count)")
        
        let converted = rawList.compactMap { raw -> CoinModel? in
            let symbol = raw.market.split(separator: "-").last.map(String.init) ?? ""
            return CoinModel(
                market: raw.market,
                koreanName: testMarketDict[raw.market] ?? "Unknown",
                symbol: symbol,
                price: formatNumber(raw.tradePrice),
                changeRate: String(format: "%.2f%%", raw.changeRate * 100),
                changeStatus: raw.change,
                volume: raw.accTradePrice24h,
                logoURL: URL(string: "https://static.upbit.com/logos/\(symbol).png")
            )
        }

        DispatchQueue.main.async {
            self.coinList = converted
            self.onUpdated?()
        }
    }
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}
