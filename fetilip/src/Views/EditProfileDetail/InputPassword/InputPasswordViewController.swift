//
//  InputPasswordViewController.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputPasswordViewController: UIViewController, ViewControllerMethodInjectable {

    struct Dependency {
        let inputPasswordSubject: BehaviorSubject<String>
        let saveInformationSubject: PublishSubject<()>
    }

    func inject(with dependency: Dependency) {
        self.inputPasswordSubject = dependency.inputPasswordSubject
        self.saveInformationSubject = dependency.saveInformationSubject
    }

    typealias ViewModel = InputPasswordViewModel

    private let viewModel: ViewModel = InputPasswordViewModel()

    // MARK: - Outlets

    @IBOutlet private weak var passwordTextField: UITextField!

    @IBOutlet private weak var authenticationButton: UIButton!

    // MARK: - Properties

    private var inputPasswordSubject: BehaviorSubject<String>?

    private var saveInformationSubject: PublishSubject<()>?

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        subscribeUI()
    }

    // MARK: - Functions

    private func subscribe() {
        authenticationButton.rx.tap.asSignal().emit(onNext: { [unowned self] in
            self.saveInformationSubject?.onNext(())
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }

    private func subscribeUI() {
        let passwordTextObservable = passwordTextField.rx.text.asObservable()
        let input = ViewModel.Input(passwordText: passwordTextObservable)
        let output = viewModel.transform(input: input)

        output.validPasswordDriver.drive(onNext: { enabled in
            self.authenticationButton.isEnabled = enabled
            self.authenticationButton.alpha = enabled ? 1.0 : 0.5
        }).disposed(by: disposeBag)

        passwordTextObservable.subscribe(onNext: { [unowned self] text in
            guard let t = text else { return }
            self.inputPasswordSubject?.onNext(t)
        }).disposed(by: disposeBag)
    }

}

final class InputPasswordViewControllerGenerator {

    private init() {}

    static func generate(inputPasswordSubject: BehaviorSubject<String>, saveInformationSubject: PublishSubject<()>) -> UIViewController {
        guard let vc = R.storyboard.inputPassword.inputPasswordViewController() else {
            assertionFailure()
            return UIViewController()
        }
        vc.inject(with: .init(inputPasswordSubject: inputPasswordSubject,
                              saveInformationSubject: saveInformationSubject))
        return vc
    }

}
