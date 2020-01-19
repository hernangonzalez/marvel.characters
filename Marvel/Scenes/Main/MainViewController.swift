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
    private let imageProvider: ImageProvider
    private let transition = TransitionDelegate()

    // MARK: Model
    private let viewModel: MainViewViewModel
    private var bindings: [AnyCancellable] = .init()

    // MARK: Properties
    private weak var collectionView: UICollectionView!

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.placeholder = viewModel.searchPlaceholder
        bar.delegate = self
        return bar
    }()

    private lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .systemRed
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var dataSource = MainModels.DataSource(collectionView: collectionView) { [unowned self] collection, path, item  in
        switch item {
        case let .hero(_, model):
            let cell = collection.loadCell(for: path) as HeroCell?
            cell?.imageProvider = self.imageProvider
            cell?.update(with: model)
            cell?.delegate = self
            return cell
        case .loading:
            let cell = collection.loadCell(for: path) as LoadingCell?
            cell?.updateContent()
            return cell
        }
    }

    // MARK: Lifecycle
    init(model: MainViewViewModel, loader: ImageProvider) {
        viewModel = model
        imageProvider = loader
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        transitioningDelegate = transition
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
        collection.alwaysBounceVertical = true
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
        viewModel
            .viewNeedsUpdate
            .sink(receiveValue: { [unowned self] in self.updateContent() })
            .store(in: &bindings)
    }

    private func updateContent() {
        dataSource.apply(viewModel.snapshot)
        if viewModel.inProgress {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }

    // MARK: Navigation
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        if item.titleView == nil {
            item.titleView = searchBar
        }
        if item.rightBarButtonItem == nil {
            item.rightBarButtonItem = UIBarButtonItem(customView: activityView)
        }
        return item
    }
}

// MARK: - HeroCellDelegate
extension MainViewController: HeroCellDelegate {
    func heroCellDidToggleStar(_ sender: HeroCell) {
        let path = collectionView.indexPath(for: sender)
        let item = path.flatMap { dataSource.itemIdentifier(for: $0) }
        switch item {
        case let .hero(id, _):
            viewModel.toggleStart(id: id)
        default:
            break
        }
    }
}

// MARK: - Routing
private extension MainViewController {
    func presentDetailScene(with id: Int) {
        guard let viewModel = viewModel.detail(with: id) else {
            print("Could not find model with: \(id)")
            return
        }

        let detail = CharacterDetailViewController(model: viewModel, provider: imageProvider)
        let nav = UINavigationController(rootViewController: detail)
        nav.navigationBar.isTranslucent = true
        nav.modalPresentationStyle = .fullScreen
        nav.transitioningDelegate = transition
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        switch item {
        case let .hero(id, _):
            presentDetailScene(with: id)
        default:
            break
        }
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
