//
//  AppleHealthKit+Methods_Results.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - Results Methods

    func results_getBloodGlucoseSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else { return }

        let mmolPerL = HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: mmolPerL)
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(bloodGlucoseType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the glucose sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the glucose sample", error, nil)])
                return
            }
        })
    }

    func results_getInsulinDeliverySamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let insulinDeliveryType = HKQuantityType.quantityType(forIdentifier: .insulinDelivery) else { return }

        let unit = HKUnit.internationalUnit()

        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(insulinDeliveryType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the glucose sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the glucose sample", error, nil)])
                return
            }
        })
    }

    func results_getCarbohydratesSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let carbohydratesType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates) else { return }
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.gram())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(carbohydratesType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the carbohydates sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the carbohydates sample", error, nil)])
                return
            }
        })
    }

    func results_saveInsulinDeliverySample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let insulinDeliveryType = HKQuantityType.quantityType(forIdentifier: .insulinDelivery) else { return }

        let unit = HKUnit.internationalUnit()

        let value = AppleHealthKit.doubleValueFromOptions(input)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: Date())
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: startDate)
        let metadata = AppleHealthKit.metadataFromOptions(input, withDefault: nil)

        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let sample = HKQuantitySample(
            type: insulinDeliveryType,
            quantity: quantity,
            start: startDate!,
            end: endDate!,
            metadata: metadata as? [String: Any]
        )

        self.healthStore?.save(sample, withCompletion: { (success, error) in
            if !success {
                NSLog("An error occured while saving the insulin sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while saving the insulin sample", error, nil)])
                return
            }
            callback([NSNull(), sample.uuid.uuidString])
        })
    }

    func results_saveBloodGlucoseSample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else { return }

        let mmolPerL = HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())

        let value = AppleHealthKit.doubleValueFromOptions(input)
        // Undocumented `date` property was used before, keeping for backwards compatibility.
        let sampleDate = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: sampleDate)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: startDate)
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: mmolPerL)
        let metadata = AppleHealthKit.metadataFromOptions(input, withDefault: nil)

        let glucoseQuantity = HKQuantity(unit: unit, doubleValue: value)
        let glucoseSample = HKQuantitySample(
            type: bloodGlucoseType,
            quantity: glucoseQuantity,
            start: startDate!,
            end: endDate!,
            metadata: metadata as? [String: Any]
        )

        self.healthStore?.save(glucoseSample, withCompletion: { (success, error) in
            if !success {
                NSLog("An error occured while saving the glucose sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while saving the glucose sample", error, nil)])
                return
            }
            callback([NSNull(), glucoseSample.uuid.uuidString])
        })
    }

    func results_saveCarbohydratesSample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let carbohydratesType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates) else { return }

        let value = AppleHealthKit.doubleValueFromOptions(input)
        let sampleDate = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.gram())
        let metadata = AppleHealthKit.metadataFromOptions(input, withDefault: nil)

        let carbQuantity = HKQuantity(unit: unit, doubleValue: value)
        let carbSample = HKQuantitySample(
            type: carbohydratesType,
            quantity: carbQuantity,
            start: sampleDate!,
            end: sampleDate!,
            metadata: metadata as? [String: Any]
        )

        self.healthStore?.save(carbSample, withCompletion: { (success, error) in
            if !success {
                NSLog("An error occured while saving the carbohydrate sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while saving the carbohydrate sample", error, nil)])
                return
            }
            callback([NSNull(), carbSample.uuid.uuidString])
        })
    }

    func results_deleteBloodGlucoseSample(_ oid: String, callback: @escaping RCTResponseSenderBlock) {
        guard let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else { return }
        guard let uuid = UUID(uuidString: oid) else {
            callback([RCTMakeError("Invalid UUID", nil, nil)])
            return
        }
        let uuidPredicate = HKQuery.predicateForObject(with: uuid)
        self.healthStore?.deleteObjects(of: bloodGlucoseType, predicate: uuidPredicate, withCompletion: { (success, deletedObjectCount, error) in
            if !success {
                NSLog("An error occured while deleting the glucose sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while deleting the glucose sample", error, nil)])
                return
            }
            callback([NSNull(), deletedObjectCount])
        })
    }

    func results_deleteCarbohydratesSample(_ oid: String, callback: @escaping RCTResponseSenderBlock) {
        guard let carbohydratesType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates) else { return }
        guard let uuid = UUID(uuidString: oid) else {
            callback([RCTMakeError("Invalid UUID", nil, nil)])
            return
        }
        let uuidPredicate = HKQuery.predicateForObject(with: uuid)
        self.healthStore?.deleteObjects(of: carbohydratesType, predicate: uuidPredicate, withCompletion: { (success, deletedObjectCount, error) in
            if !success {
                NSLog("An error occured while deleting the carbohydrate sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while deleting the carbohydrate sample", error, nil)])
                return
            }
            callback([NSNull(), deletedObjectCount])
        })
    }

    func results_deleteInsulinDeliverySample(_ oid: String, callback: @escaping RCTResponseSenderBlock) {
        guard let insulinDeliveryType = HKQuantityType.quantityType(forIdentifier: .insulinDelivery) else { return }
        guard let uuid = UUID(uuidString: oid) else {
            callback([RCTMakeError("Invalid UUID", nil, nil)])
            return
        }
        let uuidPredicate = HKQuery.predicateForObject(with: uuid)
        self.healthStore?.deleteObjects(of: insulinDeliveryType, predicate: uuidPredicate, withCompletion: { (success, deletedObjectCount, error) in
            if !success {
                NSLog("An error occured while deleting the insulin delivery sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while deleting the insulin delivery sample", error, nil)])
                return
            }
            callback([NSNull(), deletedObjectCount])
        })
    }

    func results_registerObservers(_ bridge: RCTBridge, hasListeners: Bool) {
        guard let insulinType = HKObjectType.quantityType(forIdentifier: .insulinDelivery) else { return }
        self.setObserverForType(insulinType, type: "InsulinDelivery", bridge: bridge, hasListeners: hasListeners)
    }
}
