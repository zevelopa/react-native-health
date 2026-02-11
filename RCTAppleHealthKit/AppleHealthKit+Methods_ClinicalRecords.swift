//
//  AppleHealthKit+Methods_ClinicalRecords.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func clinicalRecords_getClinicalRecords(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let type = AppleHealthKit.stringFromOptions(input, key: "type", withDefault: "")

        if type.isEmpty {
            callback([RCTMakeError("type is required in options", nil, nil)])
            return
        }

        if type != "AllergyRecord" &&
            type != "ConditionRecord" &&
            type != "CoverageRecord" &&
            type != "ImmunizationRecord" &&
            type != "LabResultRecord" &&
            type != "MedicationRecord" &&
            type != "ProcedureRecord" &&
            type != "VitalSignRecord" {
            callback([RCTMakeError("invalid type, type must be one of 'AllergyRecord'|'ConditionRecord'|'CoverageRecord'|'ImmunizationRecord'|'LabResultRecord'|'MedicationRecord'|'ProcedureRecord'|'VitalSignRecord'", nil, nil)])
            return
        }

        let recordType = AppleHealthKit.clinicalTypeFromName(type)
        if recordType == nil {
            callback([RCTMakeError("the requested clinical record type is not available for this iOS version", nil, nil)])
            return
        }

        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)

        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchClinicalRecordsOfType(recordType as! HKClinicalType,
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

    func clinical_registerObserver(_ type: String, bridge: RCTBridge, hasListeners: Bool) {
        let recordType = AppleHealthKit.clinicalTypeFromName(type)
        if let recordType = recordType {
            self.setObserverForType(recordType, type: type, bridge: bridge, hasListeners: hasListeners)
        }
    }
}
