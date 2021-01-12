//
//  EditPostViewController.swift
//  fetilip
//
//  Created by yuu yamamoto on 2021/01/10.
//  Copyright © 2021 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift

class EditPostViewController: UIViewController, ViewControllerMethodInjectable {

    // MARK: - ViewModel

    typealias ViewModel = EditPostViewModel

    let viewModel: ViewModel = EditPostViewModel(postModel: PostModelClient())

    // MARK: - Init process

    struct Dependency {
        let postDomainModel: PostDomainModel
    }

    func inject(with dependency: Dependency) {
        self.postDomainModel = dependency.postDomainModel
    }

    // MARK: - Outlets

    @IBOutlet private weak var postImageView: UIImageView!

    @IBOutlet private weak var reviewTextView: UITextView!

    @IBOutlet private weak var updatePostButton: UIButton!

    // MARK: - Properties

    private var postDomainModel: PostDomainModel!

    // MARK: - Rx

    private let updatePostEvent: PublishSubject<PostDomainModel> = PublishSubject()

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribeUI()
    }

}

// MARK: - Functions

extension EditPostViewController {

    private func composeUI() {
        FirestorageLoader.loadImage(storagePath: postDomainModel.imageRef).subscribe(onSuccess: { [weak self] image in
            self?.postImageView.image = image
        }).disposed(by: rx.disposeBag)

        reviewTextView.text = postDomainModel.review
    }

    private func subscribeUI() {
        let input = ViewModel.Input(updatePostEvent: updatePostEvent)
        let output = viewModel.transform(input: input)
    }

}

final class EditPostViewControllerGenerator {

    static func generate(postDomainModel: PostDomainModel) -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(postDomainModel: postDomainModel))
        return vc
    }

    static func generateWithNavigation(postDomainModel: PostDomainModel) -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(postDomainModel: postDomainModel))
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
