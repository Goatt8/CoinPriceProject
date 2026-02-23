//
//  SocketManager.swift
//  CoinPriceProject
//
//  Created by goat on 2/11/26.
//

import Foundation
import Combine

class SocketManager: NSObject {
    static let shared = SocketManager()
    
    private var webSocket: URLSessionWebSocketTask?
    
    @Published var realTimeTicker: [String: Any] = [:]
    
    func connect() {
        let url = URL(string: "wss://api.upbit.com/websocket/v1")!
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        
        receiveMessage()
    }
    
    private func sendSubscribeMessage() {
        let allCoins = CoinDataManager.shared.allCoins
        
        let top20Coins = allCoins.prefix(20)
        
        let codes = top20Coins.map { "\"\($0.market)\"" }.joined(separator: ",")
        
        let jsonString = """
            [{"ticket":"test"},{"type":"ticker","codes":[\(codes)]}]
            """
        
        webSocket?.send(.string(jsonString)) { error in
            if let error = error { print("Send Error: \(error)") }
        }
    }
    
    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                if case .data(let data) = message {
                    do {
                        let ticker = try JSONDecoder().decode(SocketTickerModel.self, from: data)
                        
                        CoinDataManager.shared.updateRealTimePrice(with: ticker)
                    } catch {
                        
                    }
                }
                // 무한대기 - 데이터 전송받은 후에 다시 수신대기
                self?.receiveMessage()
            case .failure(let error):
                print("receiveMessage 웹소켓 수신 에러: \(error)")
            }
        }
    }
    
}

extension SocketManager: URLSessionWebSocketDelegate {
    // 연결성공
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("delegate didOpenWithProtocol: 웹소켓 연결 성공")
        sendSubscribeMessage()
    }
    
    // 연결종료 또는 실패
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("delegate didCompleteWithError 웹소켓 에러 발생: \(error)")
        } else {
            print("웹소켓 연결 종료")
        }
    }
}
