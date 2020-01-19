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
    private let starStore: StarProvider = StarStore(.standard)
    private let query: CharacterQuery = .init()
    private let needsUpdate: PassthroughSubject<Void, Never> = .init()
    private var searching: Bool
    private var characters: [Character] = .init() {
        willSet { searching = false }
        didSet { needsUpdate.send() }
    }

    init() {
        searching = true
        bindings += query
            .characters
            .receive(on: DispatchQueue.main)
            .assign(to: \.characters, on: self)
        bindings += starStore
            .storeDidUpdate
            .receive(on: DispatchQueue.main)
            .subscribe(needsUpdate)
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

    private var items: [MainModels.Item] {
        characters.map {
            let star = starStore.starred(for: $0.id)
            let model = HeroCellViewModel(from: $0, starred: star)
            return .hero(id: $0.id, model: model)
        }
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

    func toggleStart(id: Int) {
        starStore.togge(for: id)
    }
}

// MARK: - HeroCellViewModel
private extension HeroCellViewModel {
    init(from character: Character, starred: Bool) {
        self.name = character.name
        self.thumbnail = character.thumbnailURL
        self.starred = starred
    }
}
