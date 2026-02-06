//
//  FavoriteListViewController.swift
//  CoinPriceProject
//
//  Created by goat on 2/4/26.
//

import UIKit
import Combine

class FavoriteListViewController: UIViewController {
    
    var viewModel: FavoriteViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
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
        bindViewModel()
    }
    
    private func setTableView() {
        self.tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: CoinListTableViewCell.identifier)
        self.tableView.rowHeight = 64
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setNavigationController() {
        navigationItem.title = "즐겨찾기"
    }
    
    private func bindViewModel() {
        viewModel?.$favoriteCoins
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
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
        return viewModel?.favoriteCoins.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinListTableViewCell.identifier, for: indexPath) as! CoinListTableViewCell
        
        guard let vm = viewModel,
              indexPath.row < vm.favoriteCoins.count
        else { return cell }
        
        let coin = vm.favoriteCoins[indexPath.row]
        
        cell.bind(with: coin)
        
        return cell
    }
}
