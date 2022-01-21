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
}

class DetailProgrammePresenter: DetailProgrammesPresenterProtocol {
    let interactor: DetailProgrammesInteractor
    var subscriptions = Set<AnyCancellable>()
    
    init(interactor: DetailProgrammesInteractor) {
        self.interactor = interactor
    }
    
    func showDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error> {
        interactor.getDetailProgrammes(detailLink: detailLink).eraseToAnyPublisher()
    }
}
