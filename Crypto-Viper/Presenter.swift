//
//  Presenter.swift
//  Crypto-Viper
//
//  Created by Terry Jason on 2023/9/5.
//

import Foundation

// Class, protocol
// Talks to -> Interactor, router, view

enum NetWorkError: Error {
    case NetworkFail
    case ParseFail
}

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidDownloadCryptos(result: Result<[Crypto], Error>)
}

class CryptoPresenter: AnyPresenter {
    
    var router: AnyRouter?
    
    var interactor: AnyInteractor? {
        didSet {
            interactor?.downloadCryptos()
        }
    }
    
    var view: AnyView?
    
    func interactorDidDownloadCryptos(result: Result<[Crypto], Error>) {
        switch result {
        case .success(let cryptos):
            view?.update(with: cryptos)
        case .failure(let error):
            view?.updateError(with: error.localizedDescription)
        }
    }
    
}

