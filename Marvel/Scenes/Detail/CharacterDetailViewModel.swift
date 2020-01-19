//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import MarvelKit

struct CharacterDetailViewModel {
    let title: String
    let thumbnail: URL
}

extension CharacterDetailViewModel {
    init(from model: Character) {
        title = model.name
        thumbnail = model.thumbnailURL
    }
}
