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
        let updatePostDomainModelSubject: PublishSubject<PostDomainModel>
    }

    func inject(with dependency: Dependency) {
        self.postDomainModel = dependency.postDomainModel
        self.updatePostDomainModelSubject = dependency.updatePostDomainModelSubject
    }

    // MARK: - Dependencies

    private var postDomainModel: PostDomainModel!

    private var updatePostDomainModelSubject: PublishSubject<PostDomainModel>!

    // MARK: - Outlets

    @IBOutlet private weak var postImageView: UIImageView!

    @IBOutlet private weak var reviewTextView: UITextView!

    @IBOutlet private weak var updatePostButton: UIButton!

    // MARK: - Properties

    private lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "✗", style: .done, target: self, action: #selector(close))

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
        // Setup navigation controller
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.title = R._string.editPostScreen

        self.navigationController?.navigationBar.barTintColor = FetiLipColors.theme()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2

        FirestorageLoader.loadImage(storagePath: postDomainModel.imageRef).subscribe(onSuccess: { [weak self] image in
            self?.postImageView.image = image
        }).disposed(by: rx.disposeBag)

        reviewTextView.text = postDomainModel.review

        reviewTextView.becomeFirstResponder()
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
            guard let _self = self else { return }
            _self.postDomainModel.updateReview(newReview: _self.reviewTextView.text)
            self?.updatePostDomainModelSubject.onNext(_self.postDomainModel)
            self?.dismiss(animated: true)
            AppAlert.show(message: R._string.success.editPost, alertType: .success)
        }, onError: { e in
            log.error(e.localizedDescription)
            AppAlert.show(message: R._string.error.editPost, alertType: .error)
        }).disposed(by: rx.disposeBag)

        output.loading.subscribe(onNext: { bool in
            if bool {
                AppIndicator.show()
            } else {
                AppIndicator.dismiss()
            }
        }).disposed(by: rx.disposeBag)
    }

    @objc func close() {
        self.dismiss(animated: true)
    }

}

final class EditPostViewControllerGenerator {

    static func generate(postDomainModel: PostDomainModel, updatePostDomainModelSubject: PublishSubject<PostDomainModel>) -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(postDomainModel: postDomainModel, updatePostDomainModelSubject: updatePostDomainModelSubject))
        return vc
    }

    static func generateWithNavigation(postDomainModel: PostDomainModel, updatePostDomainModelSubject: PublishSubject<PostDomainModel>) -> UIViewController {
        guard let vc = R.storyboard.editPost.editPostViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(postDomainModel: postDomainModel, updatePostDomainModelSubject: updatePostDomainModelSubject))
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }

}
