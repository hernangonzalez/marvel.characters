//
//  MarvelResponse.swift
//  MarvelKit
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import Foundation

struct PageResponse<Item: Decodable>: Decodable {
    let offset: Int
    let count: Int
    let total: Int
    let results: [Item]
    var endIndex: Int { offset + count }
    var canLoadMore: Bool { endIndex < total }
}

struct MarvelResponse<DataType: Decodable>: Decodable {
    let code: Int
    let status: String
    let data: DataType
}
