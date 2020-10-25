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

    private let viewModel: ViewModel = UserDetailViewModel()

    // MARK: - init

    struct Dependency {
        let displayUserDomainModel: UserDomainModelProtocol
    }

    func inject(with dependency: Dependency) {
        self.displayUserDomainModel = dependency.displayUserDomainModel
    }

    // MARK: - Outlets

    @IBOutlet private weak var userImageView: UIImageView!

    @IBOutlet private weak var fetipointTextView: UILabel!

    @IBOutlet private weak var postCountTextView: UILabel!

    // MARK: - Properties

    private lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "✗", style: .done, target: self, action: #selector(close))

    var displayUserDomainModel: UserDomainModelProtocol?

    let firstLoadEvent: PublishSubject<UserDomainModelProtocol> = PublishSubject<UserDomainModelProtocol>()

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userDomainModel = displayUserDomainModel {
            firstLoadEvent.onNext(userDomainModel)
        }
        composeUI()
        subscribeUI()
    }

    private func composeUI() {
        userImageView.image = displayUserDomainModel?.loadedUserImage
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
    }

    private func subscribeUI() {
        let input = ViewModel.Input(firstLoadEvent: firstLoadEvent)
        let output = viewModel.transform(input: input)
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }
}

final class UserDetailViewControllerGenerator {

    static func generate(userDomainModel: UserDomainModelProtocol) -> UIViewController {
        guard let vc = R.storyboard.userDetail.userDetailViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(displayUserDomainModel: userDomainModel))
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
