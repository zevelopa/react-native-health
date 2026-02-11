//
//  AppleHealthKit+Methods_Mindfulness.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func mindfulness_getMindfulSession(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let limit = AppleHealthKit.doubleFromOptions(input, key: "limit", withDefault: Double(HKObjectQueryNoLimit))

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let type = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        let query = HKSampleQuery(sampleType: type,
                                  predicate: predicate,
                                  limit: limit,
                                  sortDescriptors: [timeSortDescriptor],
                                  resultsHandler: { query, results, error in
            if error != nil {
                NSLog("error with fetchCumulativeSumStatisticsCollection: %@", error!.localizedDescription)
                callback([RCTMakeError("error with fetchCumulativeSumStatisticsCollection", error, nil)])
                return
            }

            var data: [[String: Any]] = []

            if let results = results {
                for sample in results {
                    NSLog("sample for mindfulsession %@", sample)
                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate)
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate)

                    let elem: [String: Any] = [
                        "startDate": startDateString ?? "",
                        "endDate": endDateString ?? "",
                    ]

                    data.append(elem)
                }
            }
            callback([NSNull(), data])
        })

        self.healthStore?.execute(query)
    }

    func mindfulness_saveMindfulSession(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let value = AppleHealthKit.doubleFromOptions(input, key: "value", withDefault: 0)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil || endDate == nil {
            callback([RCTMakeError("startDate and endDate are required in options", nil, nil)])
            return
        }

        let type = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!
        let sample = HKCategorySample(type: type, value: Int(value), start: startDate!, end: endDate!)

        self.healthStore?.save(sample, withCompletion: { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), value])
        })
    }
}
