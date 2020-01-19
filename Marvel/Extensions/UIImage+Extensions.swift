//
//  UIImage+Extensions.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    static func starred(_ selected: Bool) -> UIImage? {
        let name = selected ? "star.fill" : "star"
        return UIImage(systemName: name)
    }
}
