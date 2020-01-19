//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit
import Combine

class CharacterDetailViewController: UIViewController {
    // MARK: Dependencies
    private let imageProvider: ImageProvider

    // MARK: Model
    private let viewModel: CharacterDetailViewModel
    private var bindings: [AnyCancellable] = .init()

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

        let comics = CharacterInfoView(model: viewModel.comics)
        let events = CharacterInfoView(model: viewModel.events)
        let series = CharacterInfoView(model: viewModel.series)
        let stories = CharacterInfoView(model: viewModel.stories)

        let infoStack = UIStackView(arrangedSubviews: [comics, events, series, stories])
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.axis = .vertical
        infoStack.spacing = 16

        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(infoStack)
        scroll.alwaysBounceVertical = true

        view.backgroundColor = .systemBackground
        view.addSubview(thumb)
        view.addSubview(scroll)

        NSLayoutConstraint.activate([
            thumb.topAnchor.constraint(equalTo: view.topAnchor),
            thumb.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thumb.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thumb.heightAnchor.constraint(equalTo: thumb.widthAnchor, multiplier: 0.8),

            scroll.topAnchor.constraint(equalTo: thumb.bottomAnchor, constant: 16),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.widthAnchor.constraint(equalTo: view.widthAnchor),

            infoStack.topAnchor.constraint(equalTo: scroll.topAnchor),
            infoStack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            infoStack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            infoStack.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -16)
        ])

        setupBindings()
    }

    private func setupBindings() {
        viewModel
            .viewNeedsUpdate
            .sink(receiveValue: { [unowned self] in self.updateContent() })
            .store(in: &bindings)
    }

    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        if item.rightBarButtonItem == nil {
            item.rightBarButtonItem = .init(image: UIImage.starred(viewModel.starred),
                                            style: .done,
                                            target: self,
                                            action: #selector(starDidTap))
            item.rightBarButtonItem?.tintColor = .systemYellow
        }
        if item.leftBarButtonItem == nil {
            item.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(close))
        }
        return item
    }

    // MARK: Content
    func updateContent() {
        navigationItem.rightBarButtonItem?.image = UIImage.starred(viewModel.starred)
    }

    // MARK: Star
    @objc
    private func starDidTap() {
        viewModel.togleStar()
    }

    @objc
    private func close() {
        dismiss(animated: true, completion: nil)
    }
}
