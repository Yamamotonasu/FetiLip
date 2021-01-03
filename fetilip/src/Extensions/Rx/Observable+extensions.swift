//
//  Observable+extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension ObservableType {

    /**
     * When an error comes in, issue an alert and subscribe to stream again.
     */
    func retryWithAlert() -> Observable<Element> {
        return self.retryWhen { errors in
            errors.flatMap { e -> Observable<()> in
                log.error(e.localizedDescription)
                return AppAlert.errorObservable(e)
            }
        }
    }

    /**
     * When an error comes in, issue an alert display with button and subscribe to stream again.
     */
    func retryWithRetryAlert(_ buttonAction: ((UIButton?) -> Void)) -> Observable<Element> {
        return self.retryWhen { errors in
            errors.flatMap { e -> Observable<()> in
                log.error(e.localizedDescription)
                return AppAlert.errorObservable(e)
            }
        }
    }

}
