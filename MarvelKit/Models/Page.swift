//
//  Page.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 17/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation
import Combine

public struct Page<Element> {
    public let items: [Element]
    public let next: AnyPublisher<Page, Error>?
}
