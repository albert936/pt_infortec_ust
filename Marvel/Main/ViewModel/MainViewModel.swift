//
//  MainViewModel.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import Foundation
import RxSwift

class MainViewModel {
    
    private weak var viewController: MainViewController?
    private var router: MainRouter?
    private var networkManager = NetworkManager()
    
    func bind(viewController: MainViewController, router: MainRouter) {
        self.viewController = viewController
        self.router = router
        self.router?.setSourceViewController(viewController)
    }
    
    func getCharacters() -> Observable<[Character]> {
        return networkManager.getCharacters()
    }
    
    func showCharacterDetail(characterId: Int) {
        router?.presentDetailView(characterId: characterId)
    }
}
