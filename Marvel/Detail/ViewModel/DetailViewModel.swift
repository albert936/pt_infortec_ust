//
//  DetailViewModel.swift
//  Marvel
//
//  Created by Albert on 16/11/20.
//

import Foundation
import RxSwift

class DetailViewModel {
    private weak var viewController: DetailViewController?
    private var router: DetailRouter?
    private var networkManager = NetworkManager()
    
    func bind(viewController: DetailViewController, router: DetailRouter) {
        self.viewController = viewController
        self.router = router
        self.router?.setSourceViewController(viewController)
    }
    
    func getCharacterData(id: Int) -> Observable<[CharacterDetail]> {
        return networkManager.getCharacterData(characterId: id)
    }
}
