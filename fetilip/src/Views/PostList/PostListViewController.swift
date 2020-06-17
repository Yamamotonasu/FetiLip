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

    var viewModel: ViewModel = PostListViewModel(postModel: PostModelClient())

    // MARK: - Init process

    struct Dependency {
        let isHiddenBottomBar: Bool
    }

    func inject(with dependency: Dependency) {
        self.isHiddenBottomBar = dependency.isHiddenBottomBar
    }

    // MARK: - Properties

    private let cellMargin: CGFloat = 12.0

    private var isHiddenBottomBar: Bool? = true

    private var data: [PostDomainModel] = [] {
        didSet {
            // TODO: 動作確認用
            self.lipCollectionView.reloadData()
        }
    }

    // MARK: - Outlets

    /// Collection view displaying post list.
    @IBOutlet private weak var lipCollectionView: UICollectionView!

    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        setupCollectionView()
        viewModel.fetchList()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isHiddenBottomBar == true {
            self.collectionViewBottomConstraint.constant = AppSettings.tabBarHeight + AppSettings.tabBarBottomMargin + self.view.safeAreaInsets.bottom
        }
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
    private func subscribe() {
        viewModel.fetchCompletionObservable
            .subscribe(onNext: { [weak self] domains in
                self?.data = domains
            }).disposed(by: rx.disposeBag)
    }

    /// Transition post lip page.
    private func transitionPostLipScene() {
        let vc = PostLipViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

    /// Setup collection view and set delegate masonary collection view layout.
    private func setupCollectionView() {
        lipCollectionView.dataSource = self
        lipCollectionView.contentInset = UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
        lipCollectionView.registerCustomCell(PostLipCollectionViewCell.self)
        if let collectionViewLayout = lipCollectionView.collectionViewLayout as? MasonryCollectionViewLayout {
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
        let cell = collectionView.dequeueReusableCustomCell(PostLipCollectionViewCell.self, indexPath: indexPath)
        cell.setupCell(data[indexPath.row])
        return cell

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

    /**
     * - isHiddenBottomBar: Boolean
     *  hidden tab bar → true,  not hidden → false
     */
    public static func generate(isHiddenBottomBar: Bool = true) -> UIViewController {
        guard let vc = R.storyboard.postList.postListViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(isHiddenBottomBar: isHiddenBottomBar))
        return vc
    }

}
