//
//  Network.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import Combine

enum Network {

    static func data<T: Decodable>(with request: NetworkRequest) -> AnyPublisher<T, Swift.Error> {
        data(with: request.components, session: request.session)
    }

    static func data<T: Decodable>(with components: URLComponents, session: URLSession) -> AnyPublisher<T, Error> {
        guard let url = components.url else {
            return .fail(KitError.badRequest)
        }

        return session
            .dataTaskPublisher(for: url)
            .tryMap { try $0.data.decode() as T }
            .eraseToAnyPublisher()
    }
}

protocol NetworkRequest {
    var components: URLComponents { get }
    var session: URLSession { get }
}

extension NetworkRequest {
    var session: URLSession { .shared }
}

