//
//  ActivityView.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 17/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicatorView {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style
}

// MARK: - UIViewRepresentable
extension ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
