//
//  UserDetailViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/10/25.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserDetailViewControllerProtocol: class {

}

class UserDetailViewController: UIViewController, ViewControllerMethodInjectable, UserDetailViewControllerProtocol {

    // MARK: - ViewModel

    typealias ViewModel = UserDetailViewModel

    private let viewModel: ViewModel = UserDetailViewModel(userSocialClient: UserSocialClient())

    // MARK: - init

    struct Dependency {
        let displayUserDomainModel: UserDomainModelProtocol
        let displayUserUid: String
    }

    func inject(with dependency: Dependency) {
        self.displayUserDomainModel = dependency.displayUserDomainModel
        self.displayUserUid = dependency.displayUserUid
    }

    // MARK: - Outlets

    @IBOutlet private weak var userImageView: UIImageView!

    @IBOutlet private weak var fetipointTextView: UILabel!

    @IBOutlet private weak var postCountTextView: UILabel!

    // MARK: - Properties

    private lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "✗", style: .done, target: self, action: #selector(close))

    var displayUserDomainModel: UserDomainModelProtocol?

    var displayUserUid: String?

    let firstLoadEvent: PublishSubject<String> = PublishSubject<String>()
    
    let blockSubject: PublishSubject<()> = PublishSubject<()>()

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribeUI()

        if let uid = self.displayUserUid {
            firstLoadEvent.onNext(uid)
        }
    }

    private func composeUI() {
        if let image = displayUserDomainModel?.loadedUserImage {
            userImageView.image = image
        } else {
            userImageView.image = R.image.default_icon_female()
        }
        self.navigationItem.title = displayUserDomainModel?.userName

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBarButton

        self.navigationController?.navigationBar.barTintColor = FetiLipColors.theme()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        
        let navigationBarItemImage = UIBarButtonItem(image: R.image.menu_icon(),style: .plain, target: self, action: #selector(menuTap))
        
        navigationItem.rightBarButtonItem = navigationBarItemImage
    }

    private func subscribeUI() {
        let input = ViewModel.Input(firstLoadEvent: firstLoadEvent)
        let output = viewModel.transform(input: input)

        output.userSocialDataDriver
            .map { $0.postCount }
            .drive(postCountTextView.rx.text)
            .disposed(by: rx.disposeBag)

        output.userSocialDataDriver
            .map { $0.fetiPoint }
            .drive(fetipointTextView.rx.text)
            .disposed(by: rx.disposeBag)
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    @objc private func menuTap() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "ブロックする", style: .default, handler: { [unowned self] action in
            self.blockSubject.onNext(())
        }))
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
}

final class UserDetailViewControllerGenerator {

    /**
     * Generate UserDetailViewController
     *
     * - Parameters:
     *  - userDomainModel: UserDomainModel
     *  - uid: Display user uid.
     * - Returns: UserDetailViewController instance.
     */
    static func generate(userDomainModel: UserDomainModelProtocol, uid: String) -> UIViewController {
        guard let vc = R.storyboard.userDetail.userDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(displayUserDomainModel: userDomainModel,
                              displayUserUid: uid))
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
