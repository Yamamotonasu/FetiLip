//
//  GlobalTabBarController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * メイン表示するタブバー
 */
class GlobalTabBarController: UITabBarController {

    // MARK: - ViewModel

    typealias ViewModel = GlobalTabBarViewModel

    private let viewModel = GlobalTabBarViewModel(userAuthModel: UsersAuthModel())

    // MARK: Desinable properties

    @IBInspectable public var tintColor: UIColor? {
        didSet {
            customTabBar.tintColor = tintColor
            customTabBar.reloadApperance()
        }
    }

    @IBInspectable public var tabBarBackgroundColor: UIColor? {
        didSet {
            customTabBar.backgroundColor = tabBarBackgroundColor
            customTabBar.reloadApperance()
        }
    }

    // MARK: Properties

    /// タブ表示するCustomTabBar
    lazy var customTabBar: CardTabBar = {
        return CardTabBar()
    }()

    /// タブ本体の下からの高さ
    private var bottomSpacing: CGFloat =
        AppSettings.tabBarBottomMargin

    /// タブ本体の高さ
    private var tabBarHeight: CGFloat = AppSettings.tabBarHeight

    /// 両端のスペース
    private var horizontleSpacing: CGFloat {
        return 70
    }

    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()

    private lazy var smallBottomView: UIView = {
        let anotherSmallView = UIView()
        anotherSmallView.backgroundColor = .clear
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false

        return anotherSmallView
    }()

    /// 選択中のタブ
    override var selectedIndex: Int {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    /// 選択中のVIewController
    override var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    // MARK: - Rx

    private let checkLoginEvent: PublishRelay<()> = PublishRelay<()>()

    // MARK: LifeCycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight + bottomSpacing, right: 0)

        // デフォルトのタブバーは非表示にする
        self.tabBar.isHidden = true

        addAnotherSmallView()
        setupTabBar()
        setupTabBarItems()
        customTabBar.items = tabBar.items!
        customTabBar.select(at: selectedIndex)

        subscribeUI()
        checkLoginEvent.accept(())
    }

    override func viewDidAppear(_ animated: Bool) {
        if LoginAccountData.uid == nil {
            self.transitionToFirstModal()
        }
    }

    private func addAnotherSmallView() {
        self.view.addSubview(smallBottomView)

        smallBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        let cr: NSLayoutConstraint

        if #available(iOS 11.0, *) {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight)
        } else {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: tabBarHeight)
        }

        cr.priority = .defaultHigh
        cr.isActive = true

        smallBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        smallBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func subscribeUI() {
        let input = ViewModel.Input(checkLoginEvent: checkLoginEvent)
        let output = viewModel.transform(input: input)
    }

    private func transitionToFirstModal() {
        let vc = MainModalViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

}

// MARK: Private functions

extension GlobalTabBarController {

    /// タブバーのレイアウト、色、delegateの設定
    private func setupTabBar() {
        customTabBar.delegate = self
        self.view.addSubview(customTabBar)

        customTabBar.bottomAnchor.constraint(equalTo: smallBottomView.topAnchor, constant: 0).isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontleSpacing).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true

        self.view.bringSubviewToFront(customTabBar)
        self.view.bringSubviewToFront(smallBottomView)

        customTabBar.tintColor = tintColor
    }

    /// タブの画像を設定
    private func setupTabBarItems() {
        tabBar.items?.enumerated().forEach {
            switch $0.offset {
            case TabViewControllerIndex.postList.rawValue:
                $0.element.image = R.image.tab_lip()
            case TabViewControllerIndex.myPage.rawValue:
                $0.element.image = R.image.notification()
            default:
                break
            }
        }
    }

}

// MARK: Delegate Method

extension GlobalTabBarController: CustomCardTabBarDelegate {

    func cardTabBar(_ sender: CardTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }

}

extension UITabBar {

    /// Specify tab bar height.
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 0
        return sizeThatFits
    }

}

/**
 * タブバー生成用Generator
 */
final class GlobalTabBarControllerGenerator {

    private init() {}

    public static func generate() -> UITabBarController {
        guard let tab = R.storyboard.globalTabBar.globalTabBarController() else {
            assertionFailure()
            return GlobalTabBarController()
        }
        return tab
    }

}
