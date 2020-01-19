//
//  HeroCell.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

struct HeroCellViewModel: Equatable {
    let name: String
    let thumbnail: URL
}

class HeroCell: UICollectionViewCell {
    // MARK: Constants
    static let height: CGFloat = 144

    // MARK: Dependencies
    var imageProvider: ImageProvider? {
        get { thumbnailView?.provider }
        set { thumbnailView?.provider = newValue }
    }

    // MARK: Properties
    private weak var thumbnailView: RemoteImageView!
    private weak var nameLabel: UILabel!
    private var viewModel: HeroCellViewModel?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
        contentView.clipsToBounds = true

        let thumb = RemoteImageView(frame: .zero)
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.backgroundColor = .systemRed
        thumb.contentMode = .scaleAspectFill
        thumb.alpha = 0
        contentView.addSubview(thumb)

        let name = UILabel(frame: .zero)
        name.numberOfLines = 2
        name.backgroundColor = .systemBackground
        name.textColor = .label
        name.font = .preferredFont(forTextStyle: .title2)

        let title = UIStackView(arrangedSubviews: [name])
        title.translatesAutoresizingMaskIntoConstraints = false
        title.axis = .vertical
        title.alignment = .trailing
        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            thumb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumb.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])

        nameLabel = name
        thumbnailView = thumb
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Content
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailView.prepareForReuse()
        nameLabel.text = nil
    }

    func update(with model: HeroCellViewModel) {
        viewModel = model
        nameLabel.text = model.name
        thumbnailView.update(with: model.thumbnail)
    }
}
