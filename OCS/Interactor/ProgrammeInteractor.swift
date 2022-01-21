//
//  ProgrammeInteractor.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import Foundation
import Combine

protocol ProgrammeInteractorProtocol {
    func getProgrammes(text: String)-> AnyPublisher<ResponseProgrammes, Error>
}

class ProgrammesInteractor: ProgrammeInteractorProtocol {
    
    let apiService: ProgrammesAPIService
    var subscriptions = Set<AnyCancellable>()
    
    init(apiService: ProgrammesAPIService) {
         self.apiService = apiService
     }
    
    func getProgrammes(text: String) -> AnyPublisher<ResponseProgrammes, Error> {
        apiService.getProgrammes(text: text).eraseToAnyPublisher()
    }
    
}
