//
//  File.swift
//  CoinPriceProject
//
//  Created by goat on 2/3/26.
//

import Foundation

extension Double {
    // 1,000 commma
    var formattedThousandNumComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // 자릿수
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    // 1,000,000
    var formattedMillionNum: String {
        let millionValue = self / 1_000_000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        let result = formatter.string(from: NSNumber(value: millionValue)) ?? "0"
        return "\(result)백만"
    }
    
    // 숫자 -> 문자열
    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // 소수점 둘째 자리까지
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    // 소수점 2자리 퍼센트 문자열
    func toPercentageString() -> String {
        return String(format: "%.2f%%", self * 100)
    }
}
