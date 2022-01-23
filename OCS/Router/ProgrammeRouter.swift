//
//  ProgrammeRouter.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import Foundation
import UIKit

protocol ProgrammessRouterProtocol {
    func showProgrammeDetail(for programme: Programme)
}

class ProgrammeRouter: ProgrammessRouterProtocol {
    
    let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    var storyboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
    
    func showProgrammeDetail(for programme: Programme) {
        let detailProgrammeViewController = storyboard.instantiateViewController(
            identifier: identifierDetailProgrammeController
        ) { coder in
            return DetailProgrammeViewController(coder: coder)
        }
        let networkController = NetworkController()
        let api = ProgrammesAPIService(networkController: networkController)
        let interactor = DetailProgrammesInteractor(apiService: api)
        let router = DetailProgrammeRouter(currentViewController: detailProgrammeViewController)
        detailProgrammeViewController.presenter = DetailProgrammePresenter(interactor: interactor, router: router)
        detailProgrammeViewController.programme = programme
        presentingViewController.navigationController?.pushViewController(detailProgrammeViewController, animated: false)
    }
}
