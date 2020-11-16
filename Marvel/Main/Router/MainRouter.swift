//
//  MainRouter.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import UIKit

class MainRouter {
    var viewController: UIViewController {
        return createViewcontroller()
    }
    
    private var sourceViewController: UIViewController?
    
    private func createViewcontroller() -> UIViewController {
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: Bundle.main)
        return mainViewController
    }
    
    func setSourceViewController(_ sourceViewController: UIViewController?) {
        guard let viewController = sourceViewController else { fatalError("Error") }
        
        self.sourceViewController = viewController
    }
    
    func presentDetailView(characterId: Int) {
        let detailRouter = DetailRouter(characterId: characterId)
        
        sourceViewController?.navigationController?.pushViewController(detailRouter.viewController, animated: true)
    }
}
