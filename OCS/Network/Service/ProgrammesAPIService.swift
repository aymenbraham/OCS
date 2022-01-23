//
//  ProgrammesAPIService.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import Foundation
import Combine

protocol ProgrammesAPIServiceProtocol {
    var networkController: NetworkControllerProtocol { get }
    func getProgrammes(text: String) -> AnyPublisher<ResponseProgrammes, Error>
    func getDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error>
}


class ProgrammesAPIService: ProgrammesAPIServiceProtocol {
    
    var networkController: NetworkControllerProtocol
    
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }
    
    func getProgrammes(text: String) -> AnyPublisher<ResponseProgrammes, Error> {
        let endpoint = Endpoint.programmes
        let textSearch = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "https://api.ocs.fr/apps/v2/contents?search=title%3D" + textSearch!)!
        return networkController.get(type: ResponseProgrammes.self,
                                     url: url,
                                     headers: endpoint.headers)
    }
    
    func getDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error> {
        let endpoint = Endpoint.programmes
        let url = URL(string: baseUrl + detailLink)!
        return networkController.get(type: ResponsDetailProgramme.self,
                                     url: url,
                                     headers: endpoint.headers)
    }
}

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.ocs.fr"
        components.path = "/apps/v2" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var headers: [String: Any] {
        return [
            "app-id": "APP ID"
        ]
    }
}

extension Endpoint {
    static var programmes: Self {
        return Endpoint(path: "/contents?search=title%3DGame")
    }
}

protocol NetworkControllerProtocol: class {
    typealias Headers = [String: Any]
    
    func get<T>(type: T.Type,
                url: URL,
                headers: Headers
    ) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkController: NetworkControllerProtocol {
    
    func get<T: Decodable>(type: T.Type,
                           url: URL,
                           headers: Headers
    ) -> AnyPublisher<T, Error> {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
