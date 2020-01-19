//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import MarvelKit
import Combine

class CharacterDetailViewModel {
    private let starStore: StarProvider
    private let needsUpdate: PassthroughSubject<Void, Never> = .init()
    private let id: Character.ID

    let title: String
    let thumbnail: URL
    let comics: CharacterInfoViewModel
    let series: CharacterInfoViewModel
    let events: CharacterInfoViewModel
    let stories: CharacterInfoViewModel

    var viewNeedsUpdate: AnyPublisher<Void, Never> {
        needsUpdate.eraseToAnyPublisher()
    }

    var starred: Bool {
        starStore.starred(for: id)
    }

    init(from model: Character, stars: StarProvider) {
        id = model.id
        title = model.name
        thumbnail = model.thumbnailURL
        starStore = stars
        comics = .init(caption: "Comics", content: .init(bullets: model.comics.map { $0.name }))
        series = .init(caption: "Series", content: .init(bullets: model.series.map { $0.name }))
        events = .init(caption: "Events", content: .init(bullets: model.events.map { $0.name }))
        stories = .init(caption: "Stories", content: .init(bullets: model.stories.map { $0.name }))
    }

    func togleStar() {
        starStore.togge(for: id)
        needsUpdate.send()
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
