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
}

// MARK: - Decodable
extension Character: Decodable {
    struct Thumbnail: Decodable {
        let path: URL
        let `extension`: String
        var url: URL { path.appendingPathExtension(`extension`) }
    }

    enum CodingKeys: String, CodingKey {
        case name, description, thumbnail, id
    }

    public init(from decoder: Decoder) throws {
        assert(!Thread.isMainThread)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let thumb = try container.decode(forKey: .thumbnail) as Thumbnail
        id = try container.decode(forKey: .id)
        thumbnailURL = thumb.url
        name = try container.decode(forKey: .name)
        description = try container.decode(forKey: .description)
    }
}
