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
    let comics: CharacterInfoViewModel
    let series: CharacterInfoViewModel
    let events: CharacterInfoViewModel
    let stories: CharacterInfoViewModel
}

extension CharacterDetailViewModel {
    init(from model: Character) {
        title = model.name
        thumbnail = model.thumbnailURL
        comics = .init(caption: "Comics", content: .init(bullets: model.comics.map { $0.name }))
        series = .init(caption: "Series", content: .init(bullets: model.series.map { $0.name }))
        events = .init(caption: "Events", content: .init(bullets: model.events.map { $0.name }))
        stories = .init(caption: "Stories", content: .init(bullets: model.stories.map { $0.name }))
    }
}

private extension String {
    init(bullets list: [String]) {
        guard !list.isEmpty else {
            self = "No content available."
            return
        }
        
        self = list
            .map { "* \($0) "}
            .joined(separator: "\n")
    }
}
