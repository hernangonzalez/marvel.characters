//
//  MainViewController.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 18/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    // MARK: Dependencies
    private let imageLoader: ImageProvider

    // MARK: Model
    private let viewModel: MainViewViewModel
    private var bindings: [AnyCancellable] = .init()

    // MARK: Properties
    private weak var collectionView: UICollectionView!

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.delegate = self
        return bar
    }()

    private lazy var dataSource = MainModels.DataSource(collectionView: collectionView) { [unowned self] collection, path, item  in
        switch item {
        case let .hero(_, model):
            let cell = collection.loadCell(for: path) as HeroCell?
            cell?.imageLoader = self.imageLoader
            cell?.update(with: model)
            return cell
        case .loading:
            return collection.loadCell(for: path) as LoadingCell?
        }
    }

    // MARK: Lifecycle
    init(model: MainViewViewModel, loader: ImageProvider) {
        viewModel = model
        imageLoader = loader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Appearence
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.showsVerticalScrollIndicator = false
        collection.register(HeroCell.self)
        collection.register(LoadingCell.self)
        collection.delegate = self

        view.backgroundColor = .white
        view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leftAnchor.constraint(equalTo: view.leftAnchor),
            collection.rightAnchor.constraint(equalTo: view.rightAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView = collection
        setupBindings()
    }

    private func setupBindings() {
        let binding = viewModel
            .viewNeedsUpdate
            .sink(receiveValue: updateContent)
        bindings.append(binding)
    }

    private func updateContent() {
        dataSource.apply(viewModel.snapshot)
    }

    // MARK: Navigation
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.titleView = searchBar
        return item
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }

        let width = collectionView.bounds.width
        switch item {
        case .hero:
            return .init(width: width, height: HeroCell.height)
        case .loading:
            return .init(width: width, height: LoadingCell.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        switch item {
        case .loading:
            viewModel.loadMore()
        default:
            break
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.apply(search: searchText)
    }
}
