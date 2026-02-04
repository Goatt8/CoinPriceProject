//
//  NetworkService.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    // MARK: - UpbitData 불러오기
    func fetchUpbiteData(markets: String, completion: @escaping (Result<[UpbitRawData], AFError>) -> Void) {
        let url = "https://api.upbit.com/v1/ticker"
        let parameters: Parameters = ["markets": markets]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .validate()
            .responseDecodable(of: [UpbitRawData].self) { response in
                completion(response.result)
            }
    }
    
    // MARK: - Market 불러오기
    func fetchMarketList(completion: @escaping (Result<[UpbitMarketCode], AFError>) -> Void) {
        let url = "https://api.upbit.com/v1/market/all?isDetails=false"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: [UpbitMarketCode].self) { response in
                completion(response.result)
            }
    }
    
    
    
}
