//
//  AppleHealthKit+Methods_Characteristic.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func characteristic_getBiologicalSex(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        var error: NSError?
        var bioSex: HKBiologicalSexObject?
        do {
            bioSex = try self.healthStore?.biologicalSex()
        } catch let err as NSError {
            error = err
        }

        var value: String?

        switch bioSex?.biologicalSex {
        case .notSet:
            value = "unknown"
        case .female:
            value = "female"
        case .male:
            value = "male"
        case .other:
            value = "other"
        default:
            break
        }

        if value == nil {
            callback([RCTJSErrorFromNSError(error)])
            return
        }

        let response: [String: Any] = [
            "value": value!,
        ]

        callback([NSNull(), response])
    }

    func characteristic_getDateOfBirth(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        var error: NSError?
        var dob: Date?
        do {
            dob = try self.healthStore?.dateOfBirth()
        } catch let err as NSError {
            error = err
        }

        if error != nil {
            callback([RCTJSErrorFromNSError(error)])
            return
        }
        if dob == nil {
            let response: [String: Any] = [
                "value": NSNull(),
                "age": NSNull()
            ]
            callback([NSNull(), response])
            return
        }

        let dobString = AppleHealthKit.buildISO8601StringFromDate(dob!)

        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: dob!, to: now)
        let ageInYears = ageComponents.year!

        let response: [String: Any] = [
            "value": dobString ?? NSNull(),
            "age": ageInYears,
        ]

        callback([NSNull(), response])
    }

    func characteristic_getBloodType(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        var error: NSError?
        var bioBlood: HKBloodTypeObject?
        do {
            bioBlood = try self.healthStore?.bloodType()
        } catch let err as NSError {
            error = err
        }

        var value: String?

        switch bioBlood?.bloodType {
        case .notSet:
            value = "unknown"
        case .aPositive:
            value = "A+"
        case .aNegative:
            value = "A-"
        case .bPositive:
            value = "B+"
        case .bNegative:
            value = "B-"
        case .abPositive:
            value = "AB+"
        case .abNegative:
            value = "AB-"
        case .oPositive:
            value = "O+"
        case .oNegative:
            value = "O-"
        default:
            break
        }

        if value == nil {
            callback([RCTJSErrorFromNSError(error)])
            return
        }

        let response: [String: Any] = [
            "value": value!,
        ]

        callback([NSNull(), response])
    }
}
