//
//  DetailProgrammeInteractor.swift
//  OCS
//
//  Created by aymen braham on 21/01/2022.
//

import Foundation
import Combine

protocol DetailProgrammeInteractorProtocol {
    func getDetailProgrammes(detailLink: String)-> AnyPublisher<ResponsDetailProgramme, Error>
}

class DetailProgrammesInteractor: DetailProgrammeInteractorProtocol {
    
    let apiService: ProgrammesAPIService
    var subscriptions = Set<AnyCancellable>()
    
    init(apiService: ProgrammesAPIService) {
         self.apiService = apiService
     }
    
    func getDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error> {
        apiService.getDetailProgrammes(detailLink: detailLink).eraseToAnyPublisher()
    }
    
}
