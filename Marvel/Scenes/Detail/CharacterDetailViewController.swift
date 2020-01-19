//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    // MARK: Dependencies
    private let imageProvider: ImageProvider

    // MARK: Model
    private let viewModel: CharacterDetailViewModel

    // MARK: Init
    init(model: CharacterDetailViewModel, provider: ImageProvider) {
        viewModel = model
        imageProvider = provider
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Appearence
    override func viewDidLoad() {
        super.viewDidLoad()

        let thumb = RemoteImageView(frame: .zero)
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.backgroundColor = .systemRed
        thumb.contentMode = .scaleToFill
        thumb.clipsToBounds = true
        thumb.provider = imageProvider
        thumb.update(with: viewModel.thumbnail)

        view.backgroundColor = .white
        view.addSubview(thumb)

        NSLayoutConstraint.activate([
            thumb.topAnchor.constraint(equalTo: view.topAnchor),
            thumb.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thumb.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thumb.heightAnchor.constraint(equalTo: thumb.widthAnchor, multiplier: 0.8)
        ])
    }
}
