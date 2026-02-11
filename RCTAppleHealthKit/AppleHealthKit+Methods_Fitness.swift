//
//  AppleHealthKit+Methods_Fitness.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - Step Count

    func fitness_getStepCountOnDay(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let date = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if date == nil {
            callback([RCTMakeError("could not parse date from options.date", nil, nil)])
            return
        }

        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let stepsUnit = HKUnit.count()

        self.fetchSumOfSamplesOnDayForType(stepCountType, unit: stepsUnit, includeManuallyAdded: includeManuallyAdded, day: date!) { value, startDate, endDate, error in
            if error != nil {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let response: [String: Any] = [
                "value": value,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func fitness_getDailyStepSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.count())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!

        self.fetchCumulativeSumStatisticsCollection(stepCountType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: limit, includeManuallyAdded: includeManuallyAdded) { arr, err in
            if err != nil {
                callback([RCTJSErrorFromNSError(err)])
                return
            }
            callback([NSNull(), arr!])
        }
    }

    func fitness_saveSteps(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let value = AppleHealthKit.doubleFromOptions(input, key: "value", withDefault: 0)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil || endDate == nil {
            callback([RCTMakeError("startDate and endDate are required in options", nil, nil)])
            return
        }

        let unit = HKUnit.count()
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let sample = HKQuantitySample(type: type, quantity: quantity, start: startDate!, end: endDate!)

        self.healthStore?.save(sample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), value])
        }
    }

    // MARK: - Distance Walking/Running

    func fitness_getDistanceWalkingRunningOnDay(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())
        let date = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!

        self.fetchSumOfSamplesOnDayForType(quantityType, unit: unit, includeManuallyAdded: includeManuallyAdded, day: date!) { distance, startDate, endDate, error in
            if error != nil {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let response: [String: Any] = [
                "value": distance,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func fitness_getDailyDistanceWalkingRunningSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!

        self.fetchCumulativeSumStatisticsCollection(quantityType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: limit, includeManuallyAdded: includeManuallyAdded) { arr, err in
            if err != nil {
                NSLog("error with fetchCumulativeSumStatisticsCollection: %@", err!.localizedDescription)
                callback([RCTMakeError("error with fetchCumulativeSumStatisticsCollection", err, nil)])
                return
            }
            callback([NSNull(), arr!])
        }
    }

    func fitness_saveWalkingRunningDistance(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let distance = AppleHealthKit.doubleValueFromOptions(input)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())

        if startDate == nil || endDate == nil {
            callback([RCTMakeError("startDate and endDate are required in options", nil, nil)])
            return
        }

        let quantity = HKQuantity(unit: unit, doubleValue: distance)
        let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let sample = HKQuantitySample(type: type, quantity: quantity, start: startDate!, end: endDate!)

        self.healthStore?.save(sample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), distance])
        }
    }

    // MARK: - Distance Cycling

    func fitness_getDistanceCyclingOnDay(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())
        let date = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceCycling)!

        self.fetchSumOfSamplesOnDayForType(quantityType, unit: unit, includeManuallyAdded: includeManuallyAdded, day: date!) { distance, startDate, endDate, error in
            if error != nil {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let response: [String: Any] = [
                "value": distance,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func fitness_getDailyDistanceCyclingSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceCycling)!

        self.fetchCumulativeSumStatisticsCollection(quantityType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: limit, includeManuallyAdded: includeManuallyAdded) { arr, err in
            if err != nil {
                callback([RCTJSErrorFromNSError(err)])
                return
            }
            callback([NSNull(), arr!])
        }
    }

    // MARK: - Distance Swimming

    func fitness_getDistanceSwimmingOnDay(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())
        let date = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceSwimming)!

        self.fetchSumOfSamplesOnDayForType(quantityType, unit: unit, includeManuallyAdded: includeManuallyAdded, day: date!) { distance, startDate, endDate, error in
            if error != nil {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let response: [String: Any] = [
                "value": distance,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func fitness_getDailyDistanceSwimmingSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.meter())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceSwimming)!

        self.fetchCumulativeSumStatisticsCollection(quantityType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: limit, includeManuallyAdded: includeManuallyAdded) { arr, err in
            if err != nil {
                callback([RCTJSErrorFromNSError(err)])
                return
            }
            callback([NSNull(), arr!])
        }
    }

    // MARK: - Flights Climbed

    func fitness_getFlightsClimbedOnDay(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = HKUnit.count()
        let date = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        let quantityType = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!

        self.fetchSumOfSamplesOnDayForType(quantityType, unit: unit, includeManuallyAdded: includeManuallyAdded, day: date!) { count, startDate, endDate, error in
            if error != nil {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let response: [String: Any] = [
                "value": count,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func fitness_getDailyFlightsClimbedSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.count())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let period = AppleHealthKit.uintFromOptions(input, key: "period", withDefault: 60)
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let quantityType = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!

        self.fetchCumulativeSumStatisticsCollection(quantityType, unit: unit, period: period, startDate: startDate!, endDate: endDate!, ascending: ascending, limit: limit, includeManuallyAdded: includeManuallyAdded) { arr, err in
            if err != nil {
                callback([RCTJSErrorFromNSError(err)])
                return
            }
            callback([NSNull(), arr!])
        }
    }

    // MARK: - Samples

    func fitness_getSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        var unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.count())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let type = AppleHealthKit.stringFromOptions(input, key: "type", withDefault: "Walking")
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: Date())
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let samplesType = AppleHealthKit.quantityTypeFromName(type) as! HKSampleType

        let completion: ([Any]?, Error?) -> Void = { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting samples:", error, nil)])
                return
            }
        }

        if type == "Running" || type == "Cycling" {
            unit = HKUnit.mile()
        }

        self.fetchSamplesOfType(samplesType, unit: unit, predicate: predicate, ascending: ascending, limit: limit, completion: completion)
    }

    // MARK: - Step Event Observer

    func fitness_initializeStepEventObserver(_ input: NSDictionary, hasListeners: Bool, callback: @escaping RCTResponseSenderBlock) {
        let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)!

        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { [weak self] query, completionHandler, error in
            if let error = error {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            if hasListeners {
                self?.sendEvent(withName: "change:steps", body: ["name": "change:steps"])
            }

            // If you have subscribed for background updates you must call the completion handler here.
            // completionHandler()
        }

        self.healthStore?.execute(query)
    }

    // MARK: - Observer Registration

    @available(*, deprecated, message: "Use initializeBackgroundObservers() instead")
    func fitness_setObserver(_ input: NSDictionary) {
        RCTLogWarn("The setObserver() method has been deprecated in favor of initializeBackgroundObservers()")

        let type = AppleHealthKit.stringFromOptions(input, key: "type", withDefault: "Walking")
        let sampleType = AppleHealthKit.quantityTypeFromName(type) as! HKSampleType

        self.setObserverForType(sampleType, type: type)
    }

    func fitness_registerObserver(_ type: String, bridge: RCTBridge, hasListeners: Bool) {
        let sampleType = AppleHealthKit.quantityTypeFromName(type) as! HKSampleType

        self.setObserverForType(sampleType, type: type, bridge: bridge, hasListeners: hasListeners)
    }
}
