//
//  DetailProgrammePresenter.swift
//  OCS
//
//  Created by aymen braham on 21/01/2022.
//

import Foundation
import Combine

protocol DetailProgrammesPresenterProtocol {
    func showDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error>
    func openVideo()
}

class DetailProgrammePresenter: DetailProgrammesPresenterProtocol {
    let interactor: DetailProgrammeInteractorProtocol
    let router: DetailProgrammeRouterProtocol
    var subscriptions = Set<AnyCancellable>()
    
    init(interactor: DetailProgrammeInteractorProtocol, router: DetailProgrammeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func showDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error> {
        interactor.getDetailProgrammes(detailLink: detailLink).eraseToAnyPublisher()
    }
    
    func openVideo() {
        router.openVideo()
    }
}
