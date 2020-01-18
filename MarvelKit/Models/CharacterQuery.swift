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
        bindings += input
            .debounce(for: .milliseconds(threshold), scheduler: queue)
            .sink(receiveValue: search(name:))
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
        cancellables += publisher.sink(receiveCompletion: search(complete:),
                                       receiveValue: append(page:))
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

    func search(complete: Subscribers.Completion<Error>) {
        print(complete)
    }

    func start(page: Page<Character>) {
        items.value = page.items
        next = page.next
    }

    func append(page: Page<Character>) {
        items.value += page.items
        next = page.next
    }
}
