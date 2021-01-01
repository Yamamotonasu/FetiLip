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
import RxDataSources
import Firebase

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
        let myPost: Bool
    }

    func inject(with dependency: Dependency) {
        self.isHiddenBottomBar = dependency.isHiddenBottomBar
        self.myPost = dependency.myPost
    }

    // MARK: - Outlets

    /// Collection view displaying post list.
    @IBOutlet weak var lipCollectionView: UICollectionView!

    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private let cellMargin: CGFloat = 15.0

    private var isHiddenBottomBar: Bool? = false

    private var myPost: Bool = false

    var selectedIndexPath: IndexPath!

    private var isLoading: Bool = false

    private let refreshControl = UIRefreshControl()

    // あんまりやりたくないけど。prepareのためにやる
    var data: [PostListSectionDomainModel] = []

    // MARK: - Rx

    private let loadEvent: PublishSubject<LoadType> = PublishSubject()

    private var result: Observable<[PostListSectionDomainModel]> = Observable.empty()

    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<PostListSectionDomainModel> = setupDataSource()

    static let deleteSubject: PublishSubject<DocumentReference> = PublishSubject()

    static let refreshSubject: PublishSubject<LoadType> = PublishSubject()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        composeUI()
        subscribeUI()
        setupCollectionView()
        if myPost {
            loadEvent.onNext(.myPost)
        } else {
            loadEvent.onNext(.firstLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewBottomConstraint.constant = AppSettings.tabBarHeight + AppSettings.tabBarBottomMargin + self.view.safeAreaInsets.bottom
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = isHiddenBottomBar == true ? 0 : 1
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

        // TODO: Make common.
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        // Setup refresh control
        lipCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(firstLoadEvent: loadEvent.asObservable(),
                                    deleteSubject: Self.deleteSubject,
                                    refreshSubject: Self.refreshSubject)
        let output = viewModel.transform(input: input)

        result = output.loadResult

        output.loadResult.do(onNext: { [weak self] data in
                self?.data = data
                self?.refreshControl.endRefreshing()
            }, onError: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(to: lipCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: rx.disposeBag)

        output.refreshResult.do(onNext: { [weak self] data in
            self?.data = data
            self?.refreshControl.endRefreshing()
        }, onError: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        })
        .bind(to: lipCollectionView.rx.items(dataSource: self.dataSource))
        .disposed(by: rx.disposeBag)

        lipCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.selectedIndexPath = indexPath
            }).disposed(by: rx.disposeBag)

        output.loadingObservable.subscribe(onNext: {
            self.isLoading = $0
        }).disposed(by: rx.disposeBag)

        output.deleteResult.do(onNext: { [weak self] data in
            self?.data = data
            self?.refreshControl.endRefreshing()
        }, onError: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        })
        .bind(to: lipCollectionView.rx.items(dataSource: self.dataSource))
        .disposed(by: rx.disposeBag)
    }

    /// Transition post lip page.
    private func transitionPostLipScene() {
        let vc = PostLipViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

    /// Setup collection view and set delegate masonary collection view layout.
    private func setupCollectionView() {
        lipCollectionView.delegate = self
        lipCollectionView.contentInset = UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
        lipCollectionView.registerCustomCell(PostLipCollectionViewCell.self)
        if let collectionViewLayout = lipCollectionView.collectionViewLayout as? MasonryCollectionViewLayout {
            collectionViewLayout.delegate = self
        }

        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width / 2) - cellMargin * 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = cellMargin
        lipCollectionView.collectionViewLayout = layout
    }

    private func setupDataSource() -> RxCollectionViewSectionedReloadDataSource<PostListSectionDomainModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PostListSectionDomainModel>(configureCell: { (_, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCustomCell(PostLipCollectionViewCell.self, indexPath: indexPath)
            cell.setupCell(item)
            return cell
        })
        return dataSource
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.postListViewController.goToPostLipDetail.identifier {
            let nav = self.navigationController
            let vc = segue.destination as! PostLipDetailViewController
            let cell = self.lipCollectionView.cellForItem(at: self.selectedIndexPath) as! PostLipCollectionViewCell
            if let domain = data.first?.items[self.selectedIndexPath.row] {
                vc.inject(with: .init(displayImage: cell.lipImage.image,
                                      postModel: domain ))
            } else {
                // ここで取れなかったらバグになるので、開発環境のみクラッシュさせる。
                assertionFailure()
            }
            nav?.delegate = vc.transitionController
            vc.transitionController.fromDelegate = self
            vc.transitionController.toDelegate = vc
        }
    }

    @objc private func refresh() {
        if myPost {
            loadEvent.onNext(.refreshMyPost)
        } else {
            loadEvent.onNext(.refresh)
        }
    }

}

// MARK: - UICollectionViewDelegate

extension PostListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: R.segue.postListViewController.goToPostLipDetail.identifier, sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // TODO: Unwrap
        let lastElement = data.first!.items.count - 5
        if indexPath.row == lastElement && !self.isLoading {
            if myPost {
                loadEvent.onNext(.myPostPaging)
            } else {
                loadEvent.onNext(.paging)
            }
        }
    }

}

// MARK: - Masonary collection view delegate

extension PostListViewController: MasonaryLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath index: IndexPath) -> CGFloat {
        if let cell = self.lipCollectionView.cellForItem(at: index) as? PostLipCollectionViewCell, let image = cell.lipImage.image {
            return image.size.height
        } else {
            return 0.0
        }
    }

}

// MARK: - UIScrollViewDelegate

extension  PostListViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let tab = self.tabBarController as? GlobalTabBarController {
            UIView.animate(withDuration: 0.1) {
                tab.customTabBar.alpha = 0
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tab = self.tabBarController as? GlobalTabBarController {
            UIView.animate(withDuration: 0.1) {
                tab.customTabBar.alpha = 1.0
            }
        }
    }

}

// MARK: - ZoomAnimatorDelegate

extension PostListViewController: ZoomAnimatorDelegate {

    func transitionWillStartWith(zoomAnimator: TransitionManager) {
    }

    func transitionDidEndWith(zoomAnimator: TransitionManager) {
        // TODO: Auto scrolling collection view.
    }

    func referenceImageView(for zoomAnimator: TransitionManager) -> UIImageView? {
        if let cell = self.lipCollectionView.cellForItem(at: self.selectedIndexPath) as? PostLipCollectionViewCell {
            return cell.lipImage
        } else {
            return UIImageView()
        }
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: TransitionManager) -> CGRect? {
        // Return collection view cell frame.
        let cell = self.lipCollectionView.cellForItem(at: self.selectedIndexPath) as! PostLipCollectionViewCell
        let cellFrame = self.lipCollectionView.convert(cell.frame, to: self.view)

        if cellFrame.minY < self.lipCollectionView.contentInset.top {
            return CGRect(x: cellFrame.minY, y: self.lipCollectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.lipCollectionView.contentInset.top - cellFrame.minY))
        }
        return cellFrame
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
    public static func generate(isHiddenBottomBar: Bool = false, myPost: Bool = false) -> UIViewController {
        guard let vc = R.storyboard.postList.postListViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(isHiddenBottomBar: isHiddenBottomBar, myPost: myPost))
        return vc
    }

}
