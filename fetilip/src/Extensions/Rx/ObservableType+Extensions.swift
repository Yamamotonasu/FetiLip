//
//  ObservableType+Extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/07/23.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension ObservableType {

    /// Confirming observable behavior.
    @available(*, message: "This method is debuging function.")
    public func printDebug(on: @escaping () -> Void = { AppIndicator.show() },
                          off: @escaping () -> Void = { AppIndicator.dismiss() }) -> RxSwift.Observable<Self.Element> {
        return self.do(onNext: { _ in
            print("**onNext")
        }, afterNext: { _ in
            print("**afterNext")
        }, onError: { _ in
            print("**onError")
        }, afterError: { _ in
            print("**afterError")
        }, onCompleted: {
            print("**onCompleted")
        }, afterCompleted: {
            print("**afterCompleted")
        }, onSubscribe: {
            print("**onSubscribe")
        }, onSubscribed: {
            print("**onSubscribed")
        }) {
            print("**disposed")
        }
    }

}
