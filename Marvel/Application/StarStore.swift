//
//  StarStore.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import Combine
import MarvelKit

protocol StarProvider {
    var storeDidUpdate: AnyPublisher<Void, Never> { get }
    func toggle(for id: Character.ID)
    func starred(for id: Character.ID) -> Bool
}

class StarStore: StarProvider {
    private let needsUpdate: PassthroughSubject<Void, Never> = .init()
    private let defaults: UserDefaults

    init(_ defaults: UserDefaults) {
        self.defaults = defaults
    }

    deinit {
        defaults.synchronize()
    }
}

extension StarStore {
    var storeDidUpdate: AnyPublisher<Void, Never> {
        needsUpdate.eraseToAnyPublisher()
    }

    func toggle(for id: Character.ID) {
        var value = defaults.bool(forKey: id.description)
        value.toggle()
        defaults.set(value, forKey: id.description)
        needsUpdate.send()
    }

    func starred(for id: Character.ID) -> Bool {
        defaults.bool(forKey: id.description)
    }
}
