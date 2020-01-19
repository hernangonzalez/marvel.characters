//
//  HeroCell.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

protocol HeroCellDelegate: AnyObject {
    func heroCellDidToggleStar(_ sender: HeroCell)
}

struct HeroCellViewModel: Equatable {
    let name: String
    let thumbnail: URL
    let starred: Bool
}

class HeroCell: UICollectionViewCell {
    // MARK: Constants
    static let height: CGFloat = 144

    // MARK: Dependencies
    var imageProvider: ImageProvider? {
        get { thumbnailView?.provider }
        set { thumbnailView?.provider = newValue }
    }
    weak var delegate: HeroCellDelegate?

    // MARK: Properties
    private weak var thumbnailView: RemoteImageView!
    private weak var nameLabel: UILabel!
    private weak var starView: UIButton!
    private var viewModel: HeroCellViewModel?

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        let thumb = RemoteImageView(frame: .zero)
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.backgroundColor = .systemRed
        thumb.contentMode = .scaleAspectFill
        thumb.alpha = 0

        let star = UIButton(type: .custom)
        star.tintColor = .systemYellow
        star.translatesAutoresizingMaskIntoConstraints = false
        star.addTarget(self, action: #selector(starDidTap), for: .touchUpInside)

        let name = UILabel(frame: .zero)
        name.numberOfLines = 2
        name.backgroundColor = .systemBackground
        name.textColor = .label
        name.font = .preferredFont(forTextStyle: .title2)

        let title = UIStackView(arrangedSubviews: [name])
        title.translatesAutoresizingMaskIntoConstraints = false
        title.axis = .vertical
        title.alignment = .trailing

        contentView.backgroundColor = .systemRed
        contentView.clipsToBounds = true
        contentView.addSubview(thumb)
        contentView.addSubview(title)
        contentView.addSubview(star)

        NSLayoutConstraint.activate([
            thumb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumb.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            star.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            star.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        nameLabel = name
        thumbnailView = thumb
        starView = star
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
        starView.setImage(.starred(model.starred), for: .normal)
        thumbnailView.update(with: model.thumbnail)
    }

    // MARK: Star
    @objc
    func starDidTap() {
        delegate?.heroCellDidToggleStar(self)
    }
}
