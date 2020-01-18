//
//  ImageLoader.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit
import Combine
import MarvelKit

protocol ImageProvider: AnyObject {
    typealias CompletionBlock = (UIImage, URL) -> Void
    func image(with url: URL, callback: @escaping CompletionBlock)
}

class ImageLoader {
    private var bindings: CancellableSet = .init()
    private var cache: NSCache<NSURL, UIImage> = .init()
    private let didUpdate: PassthroughSubject<Void, Never> = .init()
}

// MARK: - ImageProvider
extension ImageLoader: ImageProvider {
    func image(with url: URL, callback: @escaping CompletionBlock) {
        if let cached = cache.object(forKey: url as NSURL) {
            return callback(cached, url)
        }
        fetch(url: url, callback: callback)
    }
}

// MARK: - Download
private extension ImageLoader {
    struct Task {
        let image: UIImage
        let url: URL
        let callback: CompletionBlock
    }

    func fetch(url: URL, callback: @escaping CompletionBlock) {
        bindings += MarvelKit
            .image(at: url)
            .map { Task(image: $0, url: url, callback: callback) }
            .sink(receiveCompletion: download(completion:),
                  receiveValue: download(task:))
    }

    func download(completion: Subscribers.Completion<Error>) { }

    func download(task: Task) {
        cache.setObject(task.image, forKey: task.url as NSURL)
        DispatchQueue.main.async {
            task.callback(task.image, task.url)
        }
    }
}
