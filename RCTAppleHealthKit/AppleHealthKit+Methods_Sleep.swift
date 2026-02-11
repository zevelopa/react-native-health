//
//  AppleHealthKit+Methods_Sleep.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func sleep_getSleepSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)

        self.fetchSleepCategorySamplesForPredicate(predicate,
                                                   limit: limit,
                                                   ascending: ascending,
                                                   completion: { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
        })
    }
}
