//
//  Network.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

protocol NetworkRequest {
    var components: URLComponents { get }
}

// MARK: - URLSession
extension URLSession {
    static var api: URLSession { .shared }
    static var media: URLSession { .shared }
}

extension URLSession {
    func data<T: Decodable>(with request: NetworkRequest) -> AnyPublisher<T, Swift.Error> {
        data(with: request.components)
    }

    func data<T: Decodable>(with components: URLComponents) -> AnyPublisher<T, Error> {
        guard let url = components.url else {
            return .fail(KitError.badRequest)
        }
        return data(with: url)
    }

    func data<T: Decodable>(with url: URL) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: url)
            .tryMap { try $0.data.decode() as T }
            .eraseToAnyPublisher()
    }

    func image(at url: URL) -> AnyPublisher<UIImage, Error>  {
        let data = dataTaskPublisher(for: url)
        return data.tryMap { response -> UIImage in
            assert(!Thread.isMainThread)
            guard let model = UIImage(data: response.data) else {
                throw KitError.missing
            }
            return model
        }.eraseToAnyPublisher()
    }
}

