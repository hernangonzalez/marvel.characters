//
//  MarvelAPI.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation

enum MarvelPath: String {
    case characters
}

enum MarvelAPI {
    static let scheme = "https"
    static let host = "gateway.marvel.com"
    static let path = "/v1/public"
    static let publicKey = "923bfb3361713530cc128bfad997768b"
    static let privateKey = "324228f5bdd670a9c8ed519f2dbb16b49e784884"

    case characters(name: String?, offset: Int)
}

// MARK: - MarvelRequest
extension MarvelAPI: MarvelRequest {

    var queryItems: [URLQueryItem] {
        switch self {
        case let .characters(name, offset):
            return [.init(name: "nameStartsWith", value: name),
                    .init(name: "offset", value: offset.description)]
        }
    }

    var path: MarvelPath {
        switch self {
        case .characters:
            return .characters
        }
    }
}
