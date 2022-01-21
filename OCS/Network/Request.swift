//
//  Request.swift
//  OCS
//
//  Created by aymen braham on 19/01/2022.
//

import Foundation
import Combine

struct APIError: Decodable, Error {
    public let statusCode: Int
}

class APIRequest {
    
    static private func fetchRemoteURL<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ result in
                let decoder = JSONDecoder()
                guard let urlResponse = result.response as? HTTPURLResponse,
                    (200...299).contains(urlResponse.statusCode) else {
                        let apiError = try decoder.decode(APIError.self, from: result.data)
                        throw apiError
                }
                return try decoder.decode(T.self, from: result.data)
            })
        .tryCatch({ error -> AnyPublisher<T, Error> in
            guard let apiError = error as? APIError, apiError.statusCode == 401 else {
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("\(key) is not found: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        print("\(type) is not miss matched: \(context.debugDescription)")
                    default:
                        break
                    }
                    throw decodingError
                }
                else {
                    throw error
                }
            }
            return fetchRemoteURL(url).eraseToAnyPublisher()
        }).eraseToAnyPublisher()
    }
    
    static func fetchURL<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        return fetchRemoteURL(url)
    }
    
    static private func fetchLocalURL<T: Decodable>(_ path: URL) -> AnyPublisher<T, Error> {
        do {
            let content = try Data(contentsOf: path)
            return Just(content).decode(type: T.self, decoder: JSONDecoder()).eraseToAnyPublisher()
        }
        catch {
            fatalError("Can't fetch \(error.localizedDescription)")
        }
    }
}
