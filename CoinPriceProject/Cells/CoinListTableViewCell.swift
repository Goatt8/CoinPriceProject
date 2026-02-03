//
//  CoinListTableViewCell.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {
    
    static let identifier = "CoinListTableViewCell"
    
    //title
    let titleVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "nameLabel"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "symbolLabel"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //price
    let priceVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "currentPriceLabel"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let changeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "changeRateLabel"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "changeRateLabel"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //tradePrice
    let tradePrice24h: UILabel = {
        let label = UILabel()
        label.text = "tradePrice24h"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with coin: CoinModel) {
        nameLabel.text = coin.koreanName
        currentPriceLabel.text = coin.price
        changeRateLabel.text = coin.changeRate
        
        // 상태에 따른 색상 변경 로직
        switch coin.changeStatus {
        case "RISE": // 상승
            currentPriceLabel.textColor = .systemRed
            changeRateLabel.textColor = .systemRed
        case "FALL": // 하락
            currentPriceLabel.textColor = .systemBlue
            changeRateLabel.textColor = .systemBlue
        default:     // 보합
            currentPriceLabel.textColor = .label
            changeRateLabel.textColor = .label
        }
    }
    
    private func configureUI() {
        self.contentView.addSubview(titleVerticalStackView)
        self.contentView.addSubview(priceVerticalStackView)
        self.contentView.addSubview(tradePrice24h)
        
        self.titleVerticalStackView.addArrangedSubview(nameLabel)
        self.titleVerticalStackView.addArrangedSubview(symbolLabel)
        
        self.priceVerticalStackView.addArrangedSubview(currentPriceLabel)
        self.priceVerticalStackView.addArrangedSubview(horizontalStackView)
        self.horizontalStackView.addArrangedSubview(changeRateLabel)
        self.horizontalStackView.addArrangedSubview(changePriceLabel)
        
        NSLayoutConstraint.activate([
            //            titleVerticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleVerticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleVerticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceVerticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceVerticalStackView.leadingAnchor.constraint(equalTo: titleVerticalStackView.trailingAnchor, constant: 16),
            
            tradePrice24h.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tradePrice24h.leadingAnchor.constraint(equalTo: priceVerticalStackView.trailingAnchor, constant: 16)
            
            
            //            imageView.widthAnchor.constraint(equalToConstant: 24),
            //            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    
}
