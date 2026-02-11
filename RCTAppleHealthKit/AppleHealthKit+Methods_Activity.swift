//
//  AppleHealthKit+Methods_Activity.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - Active Energy Burned

    func activity_getActiveEnergyBurned(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.kilocalorie())
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        self.fetchCumulativeSumStatisticsCollection(activeEnergyType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: HKObjectQueryNoLimit, includeManuallyAdded: includeManuallyAdded) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting active energy burned samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting active energy burned samples:", error, nil)])
                return
            }
        }
    }

    // MARK: - Basal Energy Burned

    func activity_getBasalEnergyBurned(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let basalEnergyType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.kilocalorie())
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        self.fetchCumulativeSumStatisticsCollection(basalEnergyType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: HKObjectQueryNoLimit, includeManuallyAdded: includeManuallyAdded) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting basal energy burned samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting basal energy burned samples:", error, nil)])
                return
            }
        }
    }

    // MARK: - Apple Exercise Time

    func activity_getAppleExerciseTime(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.second())
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        self.fetchCumulativeSumStatisticsCollection(exerciseType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: HKObjectQueryNoLimit, includeManuallyAdded: includeManuallyAdded) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting exercise time: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting exercise time:", error, nil)])
                return
            }
        }
    }

    // MARK: - Apple Stand Time

    func activity_getAppleStandTime(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.second())
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        self.fetchCumulativeSumStatisticsCollection(exerciseType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: HKObjectQueryNoLimit, includeManuallyAdded: includeManuallyAdded) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting stand time: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting stand time:", error, nil)])
                return
            }
        }
    }
}
