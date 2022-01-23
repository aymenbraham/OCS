//
//  ProgrammePresenter.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import Foundation
import Combine

protocol ProgrammesPresenterProtocol {
    func showProgrammes(text: String) -> AnyPublisher<ResponseProgrammes, Error>
    func showProgrammeDetail(for programme: Programme)
}

class ProgrammePresenter: ProgrammesPresenterProtocol {
    
    let interactor: ProgrammeInteractorProtocol
    let router: ProgrammessRouterProtocol
    var subscriptions = Set<AnyCancellable>()
    
    
    init(interactor: ProgrammeInteractorProtocol, router: ProgrammessRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func showProgrammes(text: String) -> AnyPublisher<ResponseProgrammes, Error> {
        interactor.getProgrammes(text: text).eraseToAnyPublisher()
    }
    
    func showProgrammeDetail(for programme: Programme) {
        router.showProgrammeDetail(for: programme)
    }
}
