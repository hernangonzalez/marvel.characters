//
//  MainViewViewModel.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import MarvelKit
import Foundation
import Combine

class MainViewViewModel {
    private var bindings = CancellableSet()
    private let query: CharacterQuery = .init()
    private var searching: Bool
    private let needsUpdate: PassthroughSubject<Void, Never> = .init()
    private var items: [MainModels.Item] = .init() {
        willSet { searching = false }
        didSet { needsUpdate.send() }
    }

    init() {
        searching = true
        bindings += query
            .characters
            .map { $0.map { MainModels.Item(from: $0) }}
            .receive(on: DispatchQueue.main)
            .assign(to: \.items, on: self)
        query.apply(query: .init())
    }
}

// MARK: - Actions
extension MainViewViewModel {

    func apply(search input: String) {
        searching = true
        needsUpdate.send()
        query.apply(query: input)
    }

    func loadMore() {
        query.loadMore()
    }
}

// MARK: - Presentation
extension MainViewViewModel {

    var searchPlaceholder: String { "Search your hero." }

    var inProgress: Bool {
        searching
    }

    var viewNeedsUpdate: AnyPublisher<Void, Never> {
        needsUpdate.eraseToAnyPublisher()
    }

    var snapshot: MainModels.Snapshot {
        var snapshot = MainModels.Snapshot()
        snapshot.appendSections([.main])

        snapshot.appendItems(items)

        if query.canLoadMore {
            snapshot.appendItems([.loading])
        }

        return snapshot
    }

    func detail(with id: Int) -> CharacterDetailViewModel? {
        query.character(with: id)
            .map { CharacterDetailViewModel(from: $0) }
    }
}

private extension MainModels.Item {
    init(from character: Character) {
        let model = HeroCellViewModel(from: character)
        self = .hero(id: character.id, model: model)
    }
}

private extension HeroCellViewModel {
    init(from character: Character) {
        name = character.name
        thumbnail = character.thumbnailURL
    }
}


