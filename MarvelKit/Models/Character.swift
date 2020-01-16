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

public struct Character {
    public let name: String
    public let description: String
    let thumbnailURL: URL
}

extension Character {

    func thumbnail() -> AnyPublisher<UIImage, Error> {
        let session = URLSession.media
        return session.image(at: thumbnailURL)
    }
}

// MARK: - Decodable
extension Character: Decodable {
    struct Thumbnail: Decodable {
        let path: URL
        let `extension`: String
        var url: URL { path.appendingPathExtension(`extension`) }
    }

    enum CodingKeys: String, CodingKey {
        case name, description, thumbnail
    }

    public init(from decoder: Decoder) throws {
        assert(!Thread.isMainThread)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let thumb = try container.decode(forKey: .thumbnail) as Thumbnail
        thumbnailURL = thumb.url
        name = try container.decode(forKey: .name)
        description = try container.decode(forKey: .description)
    }
}
