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
    
    func showProgrammeDetail(for programme: Programme) {
        guard let navigationController = presentingViewController.navigationController else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var detailProgrammeViewController = DetailProgrammeViewController()
        detailProgrammeViewController = storyboard.instantiateViewController(withIdentifier: "DetailProgrammeViewController") as! DetailProgrammeViewController
        let networkController = NetworkController()
        let api = ProgrammesAPIService(networkController: networkController)
        let interactor = DetailProgrammesInteractor(apiService: api)
        detailProgrammeViewController.presenter = DetailProgrammePresenter(interactor: interactor)
        detailProgrammeViewController.programme = programme
        navigationController.pushViewController(detailProgrammeViewController, animated: true)
    }
}
    
