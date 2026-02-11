//
//  AppleHealthKit+Methods_Body.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - Weight

    func body_getLatestWeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.pound())

        self.fetchMostRecentQuantitySampleOfType(weightType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            guard let mostRecentQuantity = mostRecentQuantity else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let usersWeight = mostRecentQuantity.doubleValue(for: unit)
            let response: [String: Any] = [
                "value": usersWeight,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getWeightSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.pound())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(weightType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
        }
    }

    func body_saveWeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let weight = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: Date())
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.pound())

        let weightQuantity = HKQuantity(unit: unit, doubleValue: weight)
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let weightSample = HKQuantitySample(type: weightType, quantity: weightQuantity, start: sampleDate!, end: sampleDate!)

        self.healthStore?.save(weightSample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), weight])
        }
    }

    // MARK: - Height

    func body_getLatestHeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.inch())

        self.fetchMostRecentQuantitySampleOfType(heightType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            guard let mostRecentQuantity = mostRecentQuantity else {
                NSLog("error getting latest height: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting latest height", error, nil)])
                return
            }

            let height = mostRecentQuantity.doubleValue(for: unit)
            let response: [String: Any] = [
                "value": height,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getHeightSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.inch())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(heightType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
        }
    }

    func body_saveHeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let height = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptionsDefaultNow(input)
        let heightUnit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.inch())

        let heightQuantity = HKQuantity(unit: heightUnit, doubleValue: height)
        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let heightSample = HKQuantitySample(type: heightType, quantity: heightQuantity, start: sampleDate, end: sampleDate)

        self.healthStore?.save(heightSample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), height])
        }
    }

    // MARK: - Body Mass Index

    func body_getLatestBodyMassIndex(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!

        self.fetchMostRecentQuantitySampleOfType(bmiType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            guard let mostRecentQuantity = mostRecentQuantity else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let countUnit = HKUnit.count()
            let bmi = mostRecentQuantity.doubleValue(for: countUnit)

            let response: [String: Any] = [
                "value": bmi,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getBodyMassIndexSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
        let countUnit = HKUnit.count()
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(bmiType, unit: countUnit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
        }
    }

    func body_saveBodyMassIndex(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bmi = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptionsDefaultNow(input)
        let unit = HKUnit.count()

        let bmiQuantity = HKQuantity(unit: unit, doubleValue: bmi)
        let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
        let bmiSample = HKQuantitySample(type: bmiType, quantity: bmiQuantity, start: sampleDate, end: sampleDate)

        self.healthStore?.save(bmiSample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), bmi])
        }
    }

    // MARK: - Body Fat Percentage

    func body_getLatestBodyFatPercentage(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bodyFatPercentType = HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!

        self.fetchMostRecentQuantitySampleOfType(bodyFatPercentType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            guard let mostRecentQuantity = mostRecentQuantity else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let percentUnit = HKUnit.percent()
            var percentage = mostRecentQuantity.doubleValue(for: percentUnit)
            percentage = percentage * 100

            let response: [String: Any] = [
                "value": percentage,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getBodyFatPercentageSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let bodyFatPercentType = HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!
        let unit = HKUnit.percent()
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(bodyFatPercentType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting body fat percentage samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting body fat percentage samples:", error, nil)])
                return
            }
        }
    }

    func body_saveBodyFatPercentage(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        var percentage = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptionsDefaultNow(input)
        let unit = HKUnit.percent()

        percentage = percentage / 100

        let bodyFatPercentQuantity = HKQuantity(unit: unit, doubleValue: percentage)
        let bodyFatPercentType = HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!
        let bodyFatPercentSample = HKQuantitySample(type: bodyFatPercentType, quantity: bodyFatPercentQuantity, start: sampleDate, end: sampleDate)

        self.healthStore?.save(bodyFatPercentSample) { success, error in
            if !success {
                NSLog("error saving body fat percent sample: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error saving body fat percent sample", error, nil)])
                return
            }
            callback([NSNull(), percentage])
        }
    }

    // MARK: - Body Temperature

    func body_saveBodyTemperature(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let temperature = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: Date())
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.degreeFahrenheit())

        let temperatureQuantity = HKQuantity(unit: unit, doubleValue: temperature)
        let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
        let bodyTemperatureSample = HKQuantitySample(type: bodyTemperatureType, quantity: temperatureQuantity, start: sampleDate!, end: sampleDate!)

        self.healthStore?.save(bodyTemperatureSample) { success, error in
            if !success {
                NSLog("error saving body temperature sample: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error saving body temperature sample", error, nil)])
                return
            }
            callback([NSNull(), temperature])
        }
    }

    // MARK: - Lean Body Mass

    func body_getLatestLeanBodyMass(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let leanBodyMassType = HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!

        self.fetchMostRecentQuantitySampleOfType(leanBodyMassType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            guard let mostRecentQuantity = mostRecentQuantity else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let weightUnit = HKUnit.pound()
            let leanBodyMass = mostRecentQuantity.doubleValue(for: weightUnit)

            let response: [String: Any] = [
                "value": leanBodyMass,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getLeanBodyMassSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let leanBodyMassType = HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.pound())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(leanBodyMassType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting lean body mass samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting lean body mass samples:", error, nil)])
                return
            }
        }
    }

    func body_saveLeanBodyMass(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let mass = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: Date())
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.pound())

        let massQuantity = HKQuantity(unit: unit, doubleValue: mass)
        let massType = HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!
        let massSample = HKQuantitySample(type: massType, quantity: massQuantity, start: sampleDate!, end: sampleDate!)

        self.healthStore?.save(massSample) { success, error in
            if !success {
                NSLog("error saving lean body mass sample: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error saving lean body mass sample", error, nil)])
                return
            }
            callback([NSNull(), mass])
        }
    }

    // MARK: - Waist Circumference

    func body_getLatestWaistCircumference(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let waistCircumferenceType = HKQuantityType.quantityType(forIdentifier: .waistCircumference)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.inch())

        self.fetchMostRecentQuantitySampleOfType(waistCircumferenceType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            guard let mostRecentQuantity = mostRecentQuantity else {
                NSLog("error getting latest waist circumference: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting latest wait circumference", error, nil)])
                return
            }

            let waistCircumference = mostRecentQuantity.doubleValue(for: unit)
            let response: [String: Any] = [
                "value": waistCircumference,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getWaistCircumferenceSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let waistCircumferenceType = HKQuantityType.quantityType(forIdentifier: .waistCircumference)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.inch())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(waistCircumferenceType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
        }
    }

    func body_saveWaistCircumference(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let waistCircumference = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptionsDefaultNow(input)
        let waistCircumferenceUnit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.inch())

        let waistCircumferenceQuantity = HKQuantity(unit: waistCircumferenceUnit, doubleValue: waistCircumference)
        let waistCircumferenceType = HKQuantityType.quantityType(forIdentifier: .waistCircumference)!
        let waistCircumferenceSample = HKQuantitySample(type: waistCircumferenceType, quantity: waistCircumferenceQuantity, start: sampleDate, end: sampleDate)

        self.healthStore?.save(waistCircumferenceSample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), waistCircumference])
        }
    }

    // MARK: - Peak Flow

    func body_getLatestPeakFlow(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let peakFlowType = HKQuantityType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.liter().unitDivided(by: HKUnit.minute()))

        self.fetchMostRecentQuantitySampleOfType(peakFlowType, predicate: nil) { mostRecentQuantity, startDate, endDate, error in
            if let error = error {
                NSLog("error getting latest peak flow: %@", error.localizedDescription)
                callback([RCTMakeError("error getting latest peak flow", error, nil)])
                return
            }

            let peakFlow = mostRecentQuantity?.doubleValue(for: unit) ?? 0
            let response: [String: Any] = [
                "value": peakFlow,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func body_getPeakFlowSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let peakFlowType = HKQuantityType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.liter().unitDivided(by: HKUnit.minute()))
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(peakFlowType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
            } else {
                callback([RCTJSErrorFromNSError(error)])
            }
        }
    }

    func body_savePeakFlow(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let peakFlow = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptionsDefaultNow(input)
        let peakFlowUnit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.liter().unitDivided(by: HKUnit.minute()))

        let peakFlowQuantity = HKQuantity(unit: peakFlowUnit, doubleValue: peakFlow)
        let peakFlowType = HKQuantityType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!
        let peakFlowSample = HKQuantitySample(type: peakFlowType, quantity: peakFlowQuantity, start: sampleDate, end: sampleDate)

        self.healthStore?.save(peakFlowSample) { success, error in
            if !success {
                callback([RCTJSErrorFromNSError(error)])
                return
            }
            callback([NSNull(), peakFlow])
        }
    }
}
