//
//  AppleHealthKit+Methods_LabTests.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func labTests_getLatestBloodAlcoholContent(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bloodAlcoholContentType = HKQuantityType.quantityType(forIdentifier: .bloodAlcoholContent)!

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.percent())

        self.fetchMostRecentQuantitySampleOfType(bloodAlcoholContentType,
                                                 predicate: nil,
                                                 completion: { mostRecentQuantity, startDate, endDate, error in
            if mostRecentQuantity == nil {
                callback([RCTJSErrorFromNSError(error)])
            } else {
                // Determine the weight in the required unit.
                let usersBloodAlcoholContent = mostRecentQuantity!.doubleValue(for: unit)
                let response: [String: Any] = [
                    "value": usersBloodAlcoholContent,
                    "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate!) ?? "",
                    "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate!) ?? "",
                ]

                callback([NSNull(), response])
            }
        })
    }

    func labTests_getBloodAlcoholContentSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bloodAlcoholContentType = HKQuantityType.quantityType(forIdentifier: .bloodAlcoholContent)!

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.percent())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(bloodAlcoholContentType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
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

    func labTests_saveBloodAlcoholContent(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bloodAlcoholContent = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: Date())
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.percent())

        let bloodAlcoholContentQuantity = HKQuantity(unit: unit, doubleValue: bloodAlcoholContent)
        let bloodAlcoholContentType = HKQuantityType.quantityType(forIdentifier: .bloodAlcoholContent)!
        let bloodAlcoholContentSample = HKQuantitySample(type: bloodAlcoholContentType,
                                                         quantity: bloodAlcoholContentQuantity,
                                                         start: sampleDate!,
                                                         end: sampleDate!)

        self.healthStore?.save(bloodAlcoholContentSample, withCompletion: { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), bloodAlcoholContent])
        })
    }
}
