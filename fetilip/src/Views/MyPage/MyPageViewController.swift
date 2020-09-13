//
//  MyPageViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/03/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * マイページ
 */
class MyPageViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: Init process

    struct Dependency {
        let viewModel: MyPageViewController.ViewModel
    }

    typealias ViewModel = MyPageViewModel

    // Memo: TabBarのルートビューなので初期値を代入
    var viewModel: ViewModel = MyPageViewModel(userModel: UsersModelClient(),
                                               userSocialClient: UserSocialClient())

    func inject(with dependency: Dependency) {
        self.viewModel = dependency.viewModel
    }

    // MARK: Outlets

    /// Transition to debug view controller
    @IBOutlet private weak var debugButton: UIButton!

    /// User image
    @IBOutlet private weak var userImage: UIImageView!

    @IBOutlet private weak var fetipointLabel: UILabel!

    @IBOutlet private weak var fetiPointField: UIStackView!

    @IBOutlet private weak var postCountLabel: UILabel!

    /// Transition button to edit profile screen.
    @IBOutlet private weak var transitionToEditProfileButton: UIButton!

    /// Transition button to setting screen.
    @IBOutlet private weak var transitionToSettingButton: UIButton!

    // MARK: Properties

    let userLoadEvent: PublishSubject<()> = PublishSubject<()>()

    let userSocialLoadEvent: PublishRelay<()> = PublishRelay<()>()

    var userDomainModel: UserDomainModel?

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
        subscribeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tab = self.tabBarController as? GlobalTabBarController {
            tab.customTabBar.alpha = 1
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if ApplicationFlag.shared.needProfileUpdate {
            userLoadEvent.onNext(())
        }
        if ApplicationFlag.shared.needUserSocialUpdate {
            userSocialLoadEvent.accept(())
        }
    }

}

// MARK: Private functions

extension MyPageViewController {

    private func composeUI() {
        if FetilipBuildScheme.PRODUCTION {
            debugButton.isHidden = true
        }
        userImage.clipsToBounds = true

        // TODO: Make common.
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }

    /// Rx subscribe
    private func subscribe() {
        debugButton.rx.tap.asDriver().drive(onNext: { [unowned self] in
            self.transitionDebugScreen()
        }).disposed(by: rx.disposeBag)

        transitionToSettingButton.rx.tap.asSignal().emit(onNext: { [unowned self] in
            self.transitionToSettingScreen()
        }).disposed(by: rx.disposeBag)

        transitionToEditProfileButton.rx.tap.asSignal().emit(onNext: { [unowned self] in
            self.transitionToEditProfileScreen()
        }).disposed(by: rx.disposeBag)

        let tapGesture = UITapGestureRecognizer()
        fetiPointField.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.transitionToWhatFetilipPointScreen()
        }).disposed(by: rx.disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(userLoadEvent: userLoadEvent.asObservable(),
                                    userSocialLoadEvent: userSocialLoadEvent)
        let output = viewModel.transform(input: input)

        output.userLoadResult.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] domain in
            self?.userDomainModel = domain
            self?.drawUserData(domain)
        }, onError: { e in
            log.debug(e.localizedDescription)
        }).disposed(by: rx.disposeBag)

        output.userSocialLoadResult
            .observeOn(MainScheduler.instance)
            .map{ $0.fetiPoint }
            .bind(to: fetipointLabel.rx.text)
            .disposed(by: rx.disposeBag)

        output.userSocialLoadResult
            .observeOn(MainScheduler.instance)
            .map {$0.postCount }
            .bind(to: postCountLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }

    /// Transition to debug screen.
    private func transitionDebugScreen() {
        let vc = DebugViewControllerGenerator.generate()
        self.present(vc, animated: true)
    }

    private func transitionToSettingScreen() {
        let vc = SettingsViewControllerGenerator.generate()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /// Transition to edit prodile screen.
    private func transitionToEditProfileScreen() {
        guard let domain = self.userDomainModel else { return }
        let vc = EditProfileViewControllerGenerator.generate(userDomainModel: domain)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func transitionToWhatFetilipPointScreen() {
        let vc = WhatFetiPointViewControllerGenerator.generate()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /// Draw user information on screen.
    private func drawUserData(_ userDomain: UserDomainModel) {
        navigationItem.title = userDomain.userName

        if userDomain.hasImage {
            FirestorageLoader.loadImage(storagePath: userDomain.imageRef).subscribe(onSuccess: { [weak self] image in
                self?.userImage.image = image
            }, onError: { _ in
                    // TODO: Error handling
            }).disposed(by: rx.disposeBag)
        }
    }

}

/**
 * MyPageViewController Generator
 */
final class MyPageViewControllerGenerator {

    private init() {}

    public static func generate(viewModel: MyPageViewController.ViewModel) -> UIViewController {
        guard let vc = R.storyboard.myPage.myPageViewController() else {
            return UIViewController()
        }
        vc.inject(with: .init(viewModel: viewModel))
        return vc
    }

}
