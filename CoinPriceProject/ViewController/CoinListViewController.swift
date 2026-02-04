//
//  ViewController.swift
//  CoinPriceProject
//
//  Created by goat on 1/30/26.
//

import UIKit
import Combine

class CoinListViewController: UIViewController {
    
    private let coinViewModel = CoinViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        setupSearchController()
        updateCoins()
    }
    
    private func setTableView() {
        self.tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: CoinListTableViewCell.identifier)
        self.tableView.rowHeight = 64
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func updateCoins() {
        bindViewModel()
        coinViewModel.fetchTickerData()
    }
    
    private func bindViewModel() {
        coinViewModel.$filteredCoins
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setNavigationController() {
        navigationItem.title = "코인 목록"
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(seachButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.searchController = nil
    }
    
    private func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
    }
    
    @objc private func seachButtonTapped() {
        navigationItem.searchController = self.searchController
        DispatchQueue.main.async {
            self.searchController.isActive = true
            self.searchController.searchBar.becomeFirstResponder()
        }
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

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinViewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinListTableViewCell.identifier, for: indexPath) as! CoinListTableViewCell
        let coin = coinViewModel.filteredCoins[indexPath.row]
        cell.bind(with: coin)
        
        return cell
    }
}

extension CoinListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        coinViewModel.searchText = text
    }
}
