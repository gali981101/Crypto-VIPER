//
//  Interactor.swift
//  Crypto-Viper
//
//  Created by Terry Jason on 2023/9/5.
//

import Foundation

// Class, protocol
// Talks to -> presenter

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func downloadCryptos()
}

class CryptoInteractor: AnyInteractor {
    
    var presenter: AnyPresenter?
    
    func downloadCryptos() {
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json") else { return }
        
        urlTask(url: url)
    }
    
}


// MARK: Networking

extension CryptoInteractor {
    
    private func urlTask(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidDownloadCryptos(result: .failure(NetWorkError.NetworkFail))
                return
            }
            self?.dataHandle(data: data)
        }
        
        task.resume()
    }
    
    private func dataHandle(data: Data) {
        do {
            let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
            presenter?.interactorDidDownloadCryptos(result: .success(cryptos))
        } catch {
            presenter?.interactorDidDownloadCryptos(result: .failure(NetWorkError.ParseFail))
        }
    }
    
}
