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
            log.debug("**onNext")
        }, afterNext: { _ in
            log.debug("**afterNext")
        }, onError: { _ in
            log.debug("**onError")
        }, afterError: { _ in
            log.debug("**afterError")
        }, onCompleted: {
            log.debug("**onCompleted")
        }, afterCompleted: {
            log.debug("**afterCompleted")
        }, onSubscribe: {
            log.debug("**onSubscribe")
        }, onSubscribed: {
            log.debug("**onSubscribed")
        }) {
            log.debug("**disposed")
        }
    }

}
