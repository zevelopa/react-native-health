//
//  AppleHealthKit+Methods_Hearing.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func hearing_getEnvironmentalAudioExposure(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        if #available(iOS 13.0, *) {
            let environmentalAudioExposureType = HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!
            let unit = HKUnit.decibelAWeightedSoundPressureLevel()
            let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
            let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
            let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
            let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

            if startDate == nil {
                callback([RCTMakeError("startDate is required in options", nil, nil)])
                return
            }

            let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

            self.fetchQuantitySamplesOfType(environmentalAudioExposureType,
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
        } else {
            callback([RCTMakeError("EnvironmentalAudioExposure is not available for this iOS version", nil, nil)])
        }
    }

    func hearing_getHeadphoneAudioExposure(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        if #available(iOS 13.0, *) {
            let headphoneAudioExposure = HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!
            let unit = HKUnit.decibelAWeightedSoundPressureLevel()
            let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
            let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
            let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
            let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

            if startDate == nil {
                callback([RCTMakeError("startDate is required in options", nil, nil)])
                return
            }

            let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

            self.fetchQuantitySamplesOfType(headphoneAudioExposure,
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
        } else {
            callback([RCTMakeError("HeadphoneAudioExposure is not available for this iOS version", nil, nil)])
        }
    }
}
