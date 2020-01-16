//
//  MarvelRequest.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation

protocol MarvelRequest: NetworkRequest {
    var path: MarvelPath { get }
    var queryItems: [URLQueryItem] { get }
}

extension MarvelRequest {

    private var authItems: [URLQueryItem] {
        let ts = Date().timeIntervalSince1970.description
        let md5 = (ts + MarvelAPI.privateKey +  MarvelAPI.publicKey).md5
        return [
            .init(name: "ts", value: ts),
            .init(name: "apikey", value: MarvelAPI.publicKey),
            .init(name: "hash", value: md5)
        ]
    }

    var components: URLComponents {
        var components = URLComponents()
        components.scheme = MarvelAPI.scheme
        components.host = MarvelAPI.host
        components.path = [MarvelAPI.path, path.rawValue].joined(separator: "/")

        var items = authItems
        items.append(contentsOf: queryItems)
        components.queryItems = items.skipNip()

        return components
    }
}

// MARK: - URLQueryItem
private extension Array where Element == URLQueryItem {
    func skipNip() -> [Element] {
        filter { $0.value != nil }
    }
}
