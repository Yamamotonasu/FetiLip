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

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        composeUI()
        subscribe()
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

    private func subscribe() {
        updatePostButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.updatePostEvent.onNext(postDomainModel)
        }).disposed(by: rx.disposeBag)
    }

    private func subscribeUI() {
        let input = ViewModel.Input(reviewTextObservable: reviewTextView.rx.text.asObservable(), updatePostEvent: updatePostEvent)
        let output = viewModel.transform(input: input)

        output.updatePostResult.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
            AppAlert.show(message: "投稿を更新しました。", alertType: .success)
        }, onError: { e in
            log.error(e.localizedDescription)
            AppAlert.show(message: "投稿の更新に失敗しました。時間を置いて再度お試しください。", alertType: .error)
        }).disposed(by: rx.disposeBag)

        output.loading.subscribe(onNext: { bool in
            if bool {
                AppIndicator.show()
            } else {
                AppIndicator.dismiss()
            }
        }).disposed(by: rx.disposeBag)
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
