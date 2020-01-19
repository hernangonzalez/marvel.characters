//
//  CharacterInfoView.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 19/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit

struct CharacterInfoViewModel  {
    let caption: String
    let content: String
}

class CharacterInfoView: UIView {
    // MARK: Properties
    private weak var captionLabel: UILabel!
    private weak var contentLabel: UILabel!

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        let caption = UILabel(frame: .zero)
        caption.font = .preferredFont(forTextStyle: .headline)
        caption.textColor = .label
        caption.setContentHuggingPriority(.required, for: .horizontal)

        let content = UILabel(frame: .zero)
        content.font = .preferredFont(forTextStyle: .body)
        content.textColor = .secondaryLabel
        content.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [caption, content])
        textStack.axis = .horizontal
        textStack.alignment = .top
        textStack.spacing = 20

        let line = UIView(frame: .zero)
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [line, textStack])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 0.5),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        captionLabel = caption
        contentLabel = content
    }

    convenience init(model: CharacterInfoViewModel) {
        self.init(frame: .zero)
        update(with: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Content
    func update(with model: CharacterInfoViewModel) {
        captionLabel.text = model.caption
        contentLabel.text = model.content
    }
}
