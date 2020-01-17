//
//  MarvelKit.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//
import Foundation
import Combine
import UIKit.UIImage

enum KitError: Swift.Error {
    case badRequest
    case missing
}

public enum MarvelKit {
    static let version: Int = 1
}

// MARK: - Characters
extension MarvelKit {

    public static func characters(named name: String?) -> AnyPublisher<Page<Character>, Error> {
        characters(named: name, offset: 0)
    }

    // MARK: Internal
    static func characters(named name: String?, offset: Int) -> AnyPublisher<Page<Character>, Error> {
        typealias CharactersResponse = MarvelResponse<PageResponse<Character>>

        let api = MarvelAPI.characters(name: name, offset: offset)
        let session = URLSession.api
        let request = session.data(with: api) as AnyPublisher<CharactersResponse, Error>
        return request
            .map { Page(from: $0.data, query: name) }
            .eraseToAnyPublisher()
    }

    static func image(at url: URL) -> AnyPublisher<UIImage, Error> {
        let session = URLSession.media
        return session.image(at: url)
    }
}

private extension Page where Element == Character {
    init(from response: PageResponse<Character>, query: String?) {
        items = response.results
        if response.canLoadMore {
            next = MarvelKit.characters(named: query, offset: response.endIndex)
        } else {
            next = nil
        }
    }
}
