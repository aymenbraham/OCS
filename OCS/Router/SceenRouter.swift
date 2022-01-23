//
//  SceenRouter.swift
//  OCS
//
//  Created by aymen braham on 23/01/2022.
//

import Foundation
import UIKit

class SceneRouter {
    
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
    static let networkController = NetworkController()
    
    static func rootViewController() -> UINavigationController? {
        let navigationController = UINavigationController()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let rootViewController = storyboard.instantiateViewController(identifier: identifierProgrammeController) { coder in
            return ProgrammeViewController(coder: coder)
        }
        let api = ProgrammesAPIService(networkController: networkController)
        let router = ProgrammeRouter(presentingViewController: rootViewController)
        let interactor = ProgrammesInteractor(apiService: api)
        rootViewController.presenter = ProgrammePresenter(interactor: interactor, router: router)
        navigationController.viewControllers = [rootViewController]
        return navigationController
    }
}
