//
//  AppleHealthKit+Methods_Summary.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func summary_getActivitySummary(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        let completion: ([Any]?, Error?) -> Void = { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting summary: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting summary", error, nil)])
                return
            }
        }

        self.fetchActivitySummary(startDate, endDate: endDate, completion: completion)
    }
}
