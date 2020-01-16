//
//  MarvelKit.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//
import Foundation
import Combine

enum KitError: Swift.Error {
    case badRequest
    case missing
}

public enum MarvelKit {
    static let version: Int = 1
}

// MARK: - Characters
extension MarvelKit {

    public static func characters(named name: String?) -> AnyPublisher<[Character], Error> {
        typealias CharactersResponse = MarvelResponse<PageResponse<Character>>

        let api = MarvelAPI.characters(name: name)
        let session = URLSession.api
        let request = session.data(with: api) as AnyPublisher<CharactersResponse, Error>
        return request
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}

