//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import XCTest
import MarvelKit
import Combine
@testable import Marvel

class MainViewModelTests: XCTestCase {
    // MARK: Spies
    private var view: ViewSpy!
    private var fetcher: FetcherSpy!
    private var stars: StarsSpy!

    // MARK: Subject under test
    private var bindings: [AnyCancellable] = .init()
    private var subject: MainViewViewModel!

    override func setUp() {
        bindings = .init()
        fetcher = .init()
        stars = .init()
        view = .init()
        subject = .init(source: fetcher, stars: self.stars)
        subject.viewNeedsUpdate
            .map { true }
            .subscribe(view.needsUpdate)
            .store(in: &bindings)
    }

    func testApplyQuery() {
        // Given
        let query = "Hulk"

        // When
        subject.apply(search: query)

        // Then
        XCTAssertTrue(fetcher.didCallApplyQuery(with: query))
        XCTAssertTrue(subject.inProgress)
        XCTAssertTrue(view.needsUpdate.value)
    }

    func testLoadMore() {
        // Given

        // When
        subject.loadMore()

        // Then
        XCTAssertTrue(fetcher.didCallLoadMore)
    }

    func testToggleStar() {
        // Given
        let id = 42

        // When
        subject.toggleStart(id: id)

        // Then
        XCTAssertTrue(stars.didCallToggle(for: id))
    }
}

// MARK: - Spies
class FetcherSpy: CharacterFetcher {
    private var applyQuery: String?
    private(set) var didCallLoadMore: Bool = false

    var characters: AnyPublisher<[Character], Never> = .empty
    var canLoadMore: Bool = false
    func apply(query: String) { applyQuery = query }
    func loadMore() { didCallLoadMore = true }
    func character(with id: Character.ID) -> Character? { nil }

    func didCallApplyQuery(with q: String) -> Bool { applyQuery == q }
}

class StarsSpy: StarProvider {
    private var toggleForId: Character.ID?

    var storeDidUpdate: AnyPublisher<Void, Never> = .empty
    func toggle(for id: Character.ID) { toggleForId = id }
    func starred(for id: Character.ID) -> Bool { false }

    func didCallToggle(for id: Character.ID) -> Bool { toggleForId == id }
}

class ViewSpy {
    let needsUpdate = CurrentValueSubject<Bool, Never>(false)
}
