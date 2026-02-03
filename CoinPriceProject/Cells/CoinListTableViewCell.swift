//
//  CoinListTableViewCell.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {
    
    static let identifier = "CoinListTableViewCell"
    
    //Image
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //title
    let titleVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "nameLabel"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "symbolLabel"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .systemGray2
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
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "currentPriceLabel"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textAlignment = .right
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "changePriceLabel"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tradePrice24h: UILabel = {
        let label = UILabel()
        label.text = "24HtradePrice"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .right
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
        symbolLabel.text = coin.symbol
        currentPriceLabel.text = coin.price
        changeRateLabel.text = coin.changeRate
        changePriceLabel.text = coin.changedPrice
        tradePrice24h.text = coin.volume.formattedMillionNum
        
        switch coin.changeStatus {
        case "RISE": // 상승
            changePriceLabel.textColor = .systemRed
            changeRateLabel.textColor = .systemRed
        case "FALL": // 하락
            changePriceLabel.textColor = .systemBlue
            changeRateLabel.textColor = .systemBlue
        default:     // 보합
            changePriceLabel.textColor = .label
            changeRateLabel.textColor = .label
        }
    }
    
    private func configureUI() {
        self.contentView.addSubview(symbolImageView)
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
            
            symbolImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            titleVerticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleVerticalStackView.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 14),
            
            priceVerticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceVerticalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: titleVerticalStackView.leadingAnchor, constant: 16),
            priceVerticalStackView.trailingAnchor.constraint(equalTo: tradePrice24h.leadingAnchor, constant: -20),
            
            tradePrice24h.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tradePrice24h.leadingAnchor.constraint(greaterThanOrEqualTo: priceVerticalStackView.trailingAnchor, constant: 10),
            tradePrice24h.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tradePrice24h.widthAnchor.constraint(equalToConstant: 80),
            
            symbolImageView.widthAnchor.constraint(equalToConstant: 40),
            symbolImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    
}
