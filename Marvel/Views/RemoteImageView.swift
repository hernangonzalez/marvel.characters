//
//  RemoteImageView.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

class RemoteImageView: UIImageView {
    private var model: URL?
    var provider: ImageProvider?
}

// MARK: - Reuse
extension RemoteImageView {
    func prepareForReuse() {
        model = nil
        image = nil
    }
}

// MARK: - Content
extension RemoteImageView {
    func update(with url: URL) {
        assert(provider != nil, "Will serve you well to set an image provider first ;)")
        model = url
        provider?.image(with: url) { [weak self] image, url in
            self?.update(thumbnail: image, url: url)
        }
    }

    private func update(thumbnail: UIImage, url: URL) {
        guard model == url else {
            return
        }

        UIView.animate(withDuration: 0.35) {
            self.alpha = 1
            self.image = thumbnail
        }
    }
}
