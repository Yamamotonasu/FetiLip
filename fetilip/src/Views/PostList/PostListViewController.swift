//
//  PostListViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * PostListViewController,
 */
class PostListViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = PostListViewModel

    var viewModel: ViewModel = PostListViewModel()

    // MARK: - Init process

    struct Dependency {
        let viewModel: PostListViewController.ViewModel
    }

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: - Properties

    private let cellMargin: CGFloat = 10.0

    private var data: [PostDomainModel] = [] {
        didSet {
            // TODO: 一時的にreloadしておく
            self.lipCollectionView.reloadData()
        }
    }

    // MARK: - Outlets

    @IBOutlet private weak var lipCollectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        setupCollectionView()
        subscribeUI()
    }

}

// MARK: - Private functions

extension PostListViewController {

    private func composeUI() {
        // Delete under bar line in navigation controller.
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let item = UIImageView(image: R.image.feti_word())
        self.navigationItem.titleView = item
    }

    /// Bind UI from view model outputs.
    private func subscribeUI() {

    }

    /// Transition post lip page.
    private func transitionPostLipScene() {
        let vc = PostLipViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

    private func setupCollectionView() {
        lipCollectionView.dataSource = self
        lipCollectionView.contentInset = UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
        lipCollectionView.register(PostLipCollectionViewCell.self, forCellWithReuseIdentifier: R.reuseIdentifier.postLipCell.identifier)
        if let collectionViewLayout = lipCollectionView.collectionViewLayout as? MasonaryCollectionViewLayout {
            collectionViewLayout.delegate = self
        }
    }

}

// MARK: - CollectionView

extension PostListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.postLipCell.identifier, for: indexPath) as? PostLipCollectionViewCell {
            cell.setupCell(data[indexPath.row])
            return cell
        } else {
            assertionFailure()
            return UICollectionViewCell()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


}

// MARK: - Masonary collection view delegate

extension PostListViewController: MasonaryLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath index: IndexPath) -> CGFloat {
        let targetImage = data[index.row]
        return targetImage.image?.size.height ?? 0.0
    }

}

/**
 * PostListViewController Generator
 */
final class PostListViewControllerGenerator {

    private init() {}

    public static func generate(viewModel: PostListViewController.ViewModel) -> UIViewController {
        guard let vc = R.storyboard.postList.postListViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(viewModel: viewModel))
        return vc
    }

}
