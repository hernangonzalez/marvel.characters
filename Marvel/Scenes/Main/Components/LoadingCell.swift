//
//  LoadingCell.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    // MARK: Constants
    static let height: CGFloat = 44

    // MARK: Properties
    private weak var activityView: UIActivityIndicatorView!

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        let activity = UIActivityIndicatorView(style: .medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .systemRed

        contentView.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activity.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activity.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            activity.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])

        activityView = activity
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        activityView.startAnimating()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        activityView.stopAnimating()
    }
}
