//
//  DetailRouter.swift
//  Marvel
//
//  Created by Albert on 16/11/20.
//

import UIKit

class DetailRouter {
    var characterId: Int?
    
    var viewController: UIViewController {
        return createViewcontroller()
    }
    
    private var sourceViewController: UIViewController?
    
    private func createViewcontroller() -> UIViewController {
        let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: Bundle.main)
        detailViewController.characterId = characterId
        return detailViewController
    }
    
    init(characterId: Int? = -1) {
        self.characterId = characterId
    }
    
    func setSourceViewController(_ sourceViewController: UIViewController?) {
        guard let viewController = sourceViewController else { fatalError("Error") }
        
        self.sourceViewController = viewController
    }
}
