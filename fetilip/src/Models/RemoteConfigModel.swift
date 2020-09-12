//
//  RemoteConfigModel.swift
//  fetilip
//
//  Created by 山本裕太 on 2020/09/12.
//  Copyright © 2020 YutaYamamoto. All rights reserved.
//

import Foundation
import Firebase

/**
 * Manage remote config process model.
 */
struct RemoteConfigModel {

    init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
    }

    init(fetch: Bool = false) {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: defaultsPlist)

        if fetch {
            self.fetchParameter()
        }
    }

    private let defaultsPlist: String = "RemoteConfigDefaults"

    let remoteConfig: RemoteConfig

    private let expirationDuration: Int = FetilipBuildScheme.DEBUG ? 30 : 180

    func fetchParameter() {
        self.remoteConfig.fetch(withExpirationDuration: TimeInterval(self.expirationDuration)) { _, error in
            if let error = error {
                log.error(error)
                return
            }

            self.remoteConfig.activate { (result, error) in
                if let e = error {
                    log.error(e)
                    return
                }
                log.debug("Success activate remote config settings.")
            }
        }
    }

}
