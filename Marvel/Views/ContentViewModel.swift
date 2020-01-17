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

struct HeroRowViewModel: Identifiable {
    let id: Character.ID
    let name: String
}

extension HeroRowViewModel {
    init(from character: Character) {
        id = character.id
        name = character.name
    }
}

class ContentViewModel: ObservableObject {
    // MARK: Models
    private var page: Page<Character> = .init()
    private var characters: [Character] = .init()

    // MARK: Combine
    private var cancellables: CancellableSet = .init()
    private let needsUpdate: PassthroughSubject<Void, Never> = .init()
    var objectWillChange: AnyPublisher<Void, Never> {
        needsUpdate.eraseToAnyPublisher()
    }

    // MARK: Presentation
    var query: String = .init() {
        didSet {
        }
    }

    var rows: [HeroRowViewModel] {
        characters.map {
            HeroRowViewModel(from: $0)
        }
    }

    init() {
    }
}

// MARK: - Update
extension ContentViewModel {
    func updateResults() {
        guard let nextPage = page.next else {
            return
        }
        
        cancellables += nextPage
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: update(completion:),
                  receiveValue: update(page:))
    }

    private func update(completion: Subscribers.Completion<Error>) {
        debugPrint(completion)
    }

    private func update(page other: Page<Character>) {
        needsUpdate.send()
        characters += other.items
        page = other

        DispatchQueue.main.async {
            self.updateResults()
        }
    }
}
