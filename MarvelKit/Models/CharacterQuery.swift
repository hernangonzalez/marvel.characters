//
//  CharacterQuery.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import Combine

public class CharacterQuery {
    private let threshold = 300
    private var bindings = CancellableSet()
    private var cancellables = CancellableSet()
    private let queue = DispatchQueue(label: "queue.search")
    private let input = PassthroughSubject<String, Never>()
    private let items = CurrentValueSubject<[Character], Never>(.init())
    private var next: AnyPublisher<Page<Character>, Error>?

    public init() {
        input
            .debounce(for: .milliseconds(threshold), scheduler: queue)
            .sink(receiveValue: { [unowned self] in self.search(name: $0) })
            .store(in: &bindings)
    }
}

public extension CharacterQuery {
    var characters: AnyPublisher<[Character], Never> {
        items.eraseToAnyPublisher()
    }

    var canLoadMore: Bool {
        next != nil
    }

    func apply(query: String) {
        input.send(query)
    }

    func loadMore() {
        guard let publisher = next else {
            return
        }
        cancellables.cancel()
        publisher
            .sink(receiveCompletion: { [unowned self] in self.search(complete: $0)},
                  receiveValue: { [unowned self] in self.append(page: $0) })
            .store(in: &cancellables)
    }

    func character(with id: Character.ID) -> Character? {
        items.value.first { $0.id == id }
    }
}

// MAKR: - Internals
private extension CharacterQuery {
    func search(name: String) {
        cancellables.cancel()
        cancellables += MarvelKit
            .characters(named: name)
            .sink(receiveCompletion: search(complete:),
                  receiveValue: start(page:))
    }

    func search(complete: Subscribers.Completion<Error>) { }

    func start(page: Page<Character>) {
        items.value = page.items
        next = page.next
    }

    func append(page: Page<Character>) {
        items.value += page.items
        next = page.next
    }
}
