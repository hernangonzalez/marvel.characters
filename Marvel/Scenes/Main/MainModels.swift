//
//  MainModels.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

enum MainModels {
    enum Section {
        case main
    }

    enum Item {
        case hero(id: Int, model: HeroCellViewModel)
        case loading
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
}

extension MainModels.Item: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .hero(id, _):
            hasher.combine(id)
        default:
            hasher.combine("loading")
        }
    }
}
