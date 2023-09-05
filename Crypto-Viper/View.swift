//
//  View.swift
//  Crypto-Viper
//
//  Created by Terry Jason on 2023/9/5.
//

import Foundation
import UIKit

// Talks to -> presenter
// Class, protocol
// ViewController

protocol AnyView {
    
    var presenter: AnyPresenter? { get set }
    
    func update(with cryptos: [Crypto])
    
    func updateError(with error: String)
    
}

class CryptoViewController: UIViewController, AnyView {
    
    var presenter: AnyPresenter?
    
    var cryptos: [Crypto] = []
    
    
    // MARK: Create Component
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        
        return table
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Downloading..."
        
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        
        label.isHidden = false
        
        return label
    }()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentSetting()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layOutSetting()
    }
    
}


// MARK: Component

extension CryptoViewController {
    
    private func componentSetting() {
        tableViewSet()
        labelSet()
    }
    
    private func tableViewSet() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func labelSet() {
        view.addSubview(messageLabel)
    }
    
}


// MARK: LayOut

extension CryptoViewController {
    
    private func layOutSetting() {
        tableViewLayOut()
        labelLayOut()
        
        view.backgroundColor = .systemBackground
    }
    
    private func tableViewLayOut() {
        tableView.frame = view.bounds
    }
    
    private func labelLayOut() {
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
    }
    
}


// MARK: TableView Delegate

extension CryptoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        
        cell.contentConfiguration = content
        
        cell.backgroundColor = .systemBackground
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        
        detailVC.currency = cryptos[indexPath.row].currency
        detailVC.price = cryptos[indexPath.row].price
        
        self.present(detailVC, animated: true)
    }
    
}


// MARK: AnyView Delegate Func

extension CryptoViewController {
    
    func update(with cryptos: [Crypto]) {
        DispatchQueue.main.async { [self] in
            self.cryptos = cryptos
            whenDataLoadIn()
        }
    }
    
    func updateError(with error: String) {
        DispatchQueue.main.async { [self] in
            cryptos = []
            tableView.isHidden = true
            messageLabel.text = error
            messageLabel.isHidden = false
        }
    }
    
}


// MARK: Func

extension CryptoViewController {
    
    private func whenDataLoadIn() {
        messageLabel.isHidden = true
        tableView.reloadData()
        tableView.isHidden = false
    }
    
}


// MARK: Detail VC

class DetailViewController: UIViewController {
    
    var currency: String = ""
    var price: String = ""
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Currency"
        
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        
        label.isHidden = false
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Price"
        
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        
        label.isHidden = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(currencyLabel)
        view.addSubview(priceLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        currencyLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
        priceLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 50, width: 200, height: 50)
        
        currencyLabel.text = currency
        priceLabel.text = price
        
        currencyLabel.isHidden = false
        priceLabel.isHidden = false
    }
    
}






























