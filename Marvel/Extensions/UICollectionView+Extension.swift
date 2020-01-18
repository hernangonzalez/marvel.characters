//
//  UICollectionView+Extension.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}


public extension UICollectionView {
    func loadCell<Cell: UICollectionViewCell>(for index: IndexPath) -> Cell? {
        dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: index) as? Cell
    }

    func register<Cell: UICollectionViewCell>(_ cell: Cell.Type) {
        register(cell, forCellWithReuseIdentifier: cell.identifier)
    }
}


