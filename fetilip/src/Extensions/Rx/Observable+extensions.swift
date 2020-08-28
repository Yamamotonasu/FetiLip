//
//  Observable+extensions.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/08/29.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == () {

    /**
     * When an error comes in, issue an alert and subscribe to stream again.
     */
    func retryWithAlert() -> Observable<()> {
        return self.retryWhen { errors in
            errors.flatMap { e -> Observable<()> in
                log.error("\(e.localizedDescription)")
                return AppAlert.errorObservable(e)
            }
        }
    }

}
