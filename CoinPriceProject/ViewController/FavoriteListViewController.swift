//
//  FavoriteListViewController.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import UIKit

class FavoriteListViewController: UIViewController {
    
    private let coinViewModel = CoinViewModel()
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        configureUI()
        setTableView()
//        updateCoins()
    }
    
    private func setTableView() {
        self.tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: CoinListTableViewCell.identifier)
        self.tableView.rowHeight = 64
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
//    private func updateCoins() {
//        coinViewModel.onUpdated = { [weak self] in
//                print("화면 변환 알림 = combine")
//                self?.tableView.reloadData()
//            }
//            
//        coinViewModel.fetchTickerData()
//    }
    
    private func setNavigationController() {
        navigationItem.title = "코인 목록"
        let rightButton = UIBarButtonItem(image: UIImage(named: "icon_search"), style: .plain, target: self, action: #selector(seachButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func seachButtonTapped() {
        
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension FavoriteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinViewModel.coinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinListTableViewCell.identifier, for: indexPath) as! CoinListTableViewCell
        
        let coin = coinViewModel.coinList[indexPath.row]
        
        cell.bind(with: coin)
        
        return cell
    }
}
