//
//  ContentViewModel.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 17/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import MarvelKit
import Combine
import UIKit.UIImage

class ContentViewModel: ObservableObject {
    // MARK: Models
    private var page: AnyPublisher<Page<Character>, Error> {
        didSet { updateResults() }
    }

    private var characters: [Character] = .init() {
        willSet { needsUpdate.send() }
    }

    // MARK: Combine
    private var bindings: CancellableSet = .init()
    private var cancellables: CancellableSet = .init()
    private let needsUpdate: PassthroughSubject<Void, Never> = .init()
    var objectWillChange: AnyPublisher<Void, Never> {
        needsUpdate.eraseToAnyPublisher()
    }

    // MARK: Presentation
    let searchPlaceholder: String = "Search by name"
    @Published var query: String = .init()

    var rows: [HeroRowViewModel] {
        characters.map {
            HeroRowViewModel(from: $0)
        }
    }

    init() {
        page = MarvelKit.allCharacters()
        bindings += $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink(receiveValue: search(query:))
    }
}

// MARK: - Update
extension ContentViewModel {
    func updateResults() {
        cancellables.cancel()
        cancellables += page
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: update(completion:),
                  receiveValue: update(page:))
    }

    func search(query: String) {
        characters.removeAll()
        page = query.isEmpty ? MarvelKit.allCharacters() : MarvelKit.characters(named: query)
    }

    // MARK: Private
    private func update(completion: Subscribers.Completion<Error>) {
        debugPrint(completion)
    }

    private func update(page other: Page<Character>) {
        characters += other.items
        page = other.next ?? .empty
    }
}
