//
//  Character.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

public struct Character: Identifiable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnailURL: URL
    public let comics: [Comic]
    public let series: [Serie]
    public let events: [Event]
    public let stories: [Story]
}

public struct Comic: Decodable {
    let name: String
}

public struct Serie: Decodable {
    let name: String
}

public struct Story: Decodable {
    let name: String
}

public struct Event: Decodable {
    let name: String
}

// MARK: - Decodable
extension Character: Decodable {
    struct Thumbnail: Decodable {
        let path: URL
        let `extension`: String
        var url: URL { path.appendingPathExtension(`extension`) }
    }

    struct Collection<Item: Decodable>: Decodable {
        let items: [Item]
    }

    enum CodingKeys: String, CodingKey {
        case name, description, thumbnail, id, comics, series, events, stories
    }

    public init(from decoder: Decoder) throws {
        assert(!Thread.isMainThread)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let thumb = try container.decode(forKey: .thumbnail) as Thumbnail
        id = try container.decode(forKey: .id)
        thumbnailURL = thumb.url
        name = try container.decode(forKey: .name)
        description = try container.decode(forKey: .description)
        comics = try container.decodeCollection(forKey: .comics)
        series = try container.decodeCollection(forKey: .series)
        events = try container.decodeCollection(forKey: .events)
        stories = try container.decodeCollection(forKey: .stories)
    }
}

private extension KeyedDecodingContainer {
    func decodeCollection<Item: Decodable>(forKey key: Key) throws  -> [Item] {
        let coll = try decode(forKey: key) as Character.Collection<Item>
        return coll.items
    }
}

