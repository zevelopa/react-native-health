//
//  AppleHealthKit+Methods_Vitals.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - Vitals Methods

    func vitals_saveHeartRateSample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let timeHeartRateSampleWasTaken = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let heartRateValue = AppleHealthKit.doubleFromOptions(input, key: "value", withDefault: -99)
        if heartRateValue == -99 {
            callback([RCTMakeError("heartRateValue is required in options", nil, nil)])
            return
        }

        let count = HKUnit.count()
        let minute = HKUnit.minute()
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: count.unitDivided(by: minute))

        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let heartRate = HKQuantitySample(
            type: heartRateType,
            quantity: HKQuantity(unit: unit, doubleValue: heartRateValue),
            start: timeHeartRateSampleWasTaken!,
            end: timeHeartRateSampleWasTaken!
        )

        self.healthStore?.save(heartRate, withCompletion: { (success, error) in
            if !success {
                NSLog("An error occured saving the heart rate sample: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured saving the heart rate sample", error, nil)])
                return
            }
            callback([NSNull(), true])
        })
    }

    func vitals_getHeartRateSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }

        let count = HKUnit.count()
        let minute = HKUnit.minute()

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: count.unitDivided(by: minute))
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(heartRateType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting heart rate samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting heart rate samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getRestingHeartRate(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return }

        let count = HKUnit.count()
        let minute = HKUnit.minute()

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: count.unitDivided(by: minute))
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(restingHeartRateType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting heart rate samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting heart rate samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getWalkingHeartRateAverage(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage) else { return }

        let count = HKUnit.count()
        let minute = HKUnit.minute()

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: count.unitDivided(by: minute))
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(restingHeartRateType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting heart rate samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting heart rate samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getHeartRateVariabilitySamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }

        let unit = HKUnit.second()
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(hrvType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting heart rate variability samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting heart rate variability samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getHeartbeatSeriesSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let heartbeatSeriesType = HKSeriesType.seriesType(forIdentifier: HKDataTypeIdentifierHeartbeatSeries)!

        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: ascending)

        // Define the results handler for the SampleQuery.
        let resultsHandler: (HKSampleQuery, [HKSample]?, Error?) -> Void = { (query, results, error) in
            if let error = error {
                callback([RCTJSErrorFromNSError(error as NSError)])
                return
            }

            guard let results = results else {
                callback([RCTJSErrorFromNSError(NSError(domain: "AppleHealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "No results"]))])
                return
            }

            // explicitly send back an empty array for no results
            if results.count == 0 {
                callback([NSNull(), []])
                return
            }

            var samplesProcessed: UInt = 0
            let data = NSMutableArray(capacity: 1)

            // create a function that checks the progress of processing the samples
            // and executes the callback with the data when done
            let maybeFinish = {
                // check to see if we've processed all of the returned samples, and return if so
                if samplesProcessed == results.count {
                    callback([NSNull(), data])
                }
            }

            for sample in results {
                guard let heartbeatSample = sample as? HKHeartbeatSeriesSample else { continue }
                let startDateString = AppleHealthKit.buildISO8601StringFromDate(heartbeatSample.startDate) ?? ""
                let endDateString = AppleHealthKit.buildISO8601StringFromDate(heartbeatSample.endDate) ?? ""

                let elem: [String: Any] = [
                    "id": heartbeatSample.uuid.uuidString,
                    "sourceName": heartbeatSample.sourceRevision.source.name,
                    "sourceId": heartbeatSample.sourceRevision.source.bundleIdentifier,
                    "startDate": startDateString,
                    "endDate": endDateString,
                    "heartbeatSeries": []
                ]
                let mutableElem = NSMutableDictionary(dictionary: elem)
                data.add(mutableElem)

                // create an array to hold the series data which will be fetched asynchronously from healthkit
                let seriesData = NSMutableArray(capacity: Int(heartbeatSample.count))

                // now define the data handler for the HeartbeatSeriesQuery
                let dataHandler: (HKHeartbeatSeriesQuery, TimeInterval, Bool, Bool, Error?) -> Void = { (hrSeriesQuery, timeSinceSeriesStart, precededByGap, done, error) in
                    if error == nil {
                        // If no error exists for this data point, add the value to the heartbeatSeries array.
                        let el: [String: Any] = [
                            "timeSinceSeriesStart": timeSinceSeriesStart,
                            "precededByGap": precededByGap
                        ]
                        seriesData.add(el)
                    }

                    if done {
                        mutableElem.setObject(seriesData, forKey: "heartbeatSeries" as NSString)
                        samplesProcessed += 1
                        maybeFinish()
                    }
                }
                // Query the heartbeat series for this sample.
                let hrSeriesQuery = HKHeartbeatSeriesQuery(heartbeatSeries: heartbeatSample, dataHandler: dataHandler)
                self.healthStore?.execute(hrSeriesQuery)
            }
        }

        // Define and execute the HKSampleQuery
        let query = HKSampleQuery(
            sampleType: heartbeatSeriesType,
            predicate: predicate,
            limit: limit,
            sortDescriptors: [timeSortDescriptor],
            resultsHandler: resultsHandler
        )
        self.healthStore?.execute(query)
    }

    func vitals_getRestingHeartRateSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return }

        let count = HKUnit.count()
        let minute = HKUnit.minute()

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: count.unitDivided(by: minute))
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(restingHeartRateType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                callback([RCTJSErrorFromNSError(error! as NSError)])
                return
            }
        })
    }

    func vitals_getBodyTemperatureSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature) else { return }

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.degreeCelsius())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(bodyTemperatureType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting body temperature samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting body temperature samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getBloodPressureSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let bloodPressureCorrelationType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure) else { return }
        guard let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic) else { return }
        guard let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic) else { return }

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.millimeterOfMercury())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchCorrelationSamplesOfType(bloodPressureCorrelationType,
                                           unit: unit,
                                           predicate: predicate,
                                           ascending: ascending,
                                           limit: limit,
                                           completion: { (results, error) in
            if let results = results {
                var data = [[String: Any]]()

                for sample in results {
                    guard let sampleDict = sample as? NSDictionary else { continue }
                    guard let bloodPressureValues = sampleDict.value(forKey: "correlation") as? HKCorrelation else { continue }

                    let bloodPressureSystolicValue = bloodPressureValues.objects(for: systolicType).first as? HKQuantitySample
                    let bloodPressureDiastolicValue = bloodPressureValues.objects(for: diastolicType).first as? HKQuantitySample

                    let elem: [String: Any] = [
                        "bloodPressureSystolicValue": bloodPressureSystolicValue?.quantity.doubleValue(for: unit) ?? 0,
                        "bloodPressureDiastolicValue": bloodPressureDiastolicValue?.quantity.doubleValue(for: unit) ?? 0,
                        "startDate": sampleDict.value(forKey: "startDate") ?? "",
                        "endDate": sampleDict.value(forKey: "endDate") ?? ""
                    ]

                    data.append(elem)
                }

                callback([NSNull(), data])
                return
            } else {
                NSLog("error getting blood pressure samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting blood pressure samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getRespiratoryRateSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let respiratoryRateType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate) else { return }

        let count = HKUnit.count()
        let minute = HKUnit.minute()

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: count.unitDivided(by: minute))
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(respiratoryRateType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting respiratory rate samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting respiratory rate samples:", error, nil)])
                return
            }
        })
    }

    func vitals_getVo2MaxSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let vo2MaxType = HKQuantityType.quantityType(forIdentifier: .vo2Max) else { return }

        let ml = HKUnit.literUnit(with: .milli)
        let kg = HKUnit.gramUnit(with: .kilo)
        let min = HKUnit.minute()
        let u = ml.unitDivided(by: kg.unitMultiplied(by: min)) // ml/(kg*min)

        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: u)
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        guard let startDate = startDate else {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)
        self.fetchQuantitySamplesOfType(vo2MaxType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                let errStr = "error getting Vo2Max samples: \(String(describing: error))"
                NSLog("%@", errStr)
                callback([RCTMakeError(errStr, nil, nil)])
                return
            }
        })
    }

    func vitals_getOxygenSaturationSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        guard let oxygenSaturationType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return }

        let unit = HKUnit.percent()

        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }
        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)

        self.fetchQuantitySamplesOfType(oxygenSaturationType,
                                        unit: unit,
                                        predicate: predicate,
                                        ascending: ascending,
                                        limit: limit,
                                        completion: { (results, error) in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting oxygen saturation: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting oxygen saturation:", error, nil)])
                return
            }
        })
    }

    func vitals_getElectrocardiogramSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        if #available(iOS 14.0, *) {
            let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
            let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
            let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
            let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
            if startDate == nil {
                callback([RCTMakeError("startDate is required in options", nil, nil)])
                return
            }
            let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate!, endDate: endDate!)
            let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: ascending)

            // Define the results handler for the SampleQuery.
            let resultsHandler: (HKSampleQuery, [HKSample]?, Error?) -> Void = { (query, results, error) in
                if let error = error {
                    callback([RCTJSErrorFromNSError(error as NSError)])
                    return
                }

                guard let results = results else {
                    callback([RCTJSErrorFromNSError(NSError(domain: "AppleHealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "No results"]))])
                    return
                }

                // explicitly send back an empty array for no results
                if results.count == 0 {
                    callback([NSNull(), []])
                    return
                }

                var samplesProcessed: UInt = 0
                let data = NSMutableArray(capacity: 1)

                // create a function that checks the progress of processing the samples
                // and executes the callback with the data when done
                let maybeFinish = {
                    // check to see if we've processed all of the returned samples, and return if so
                    if samplesProcessed == results.count {
                        callback([NSNull(), data])
                    }
                }

                for sample in results {
                    guard let ecgSample = sample as? HKElectrocardiogram else { continue }
                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(ecgSample.startDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(ecgSample.endDate) ?? ""

                    let classification: String
                    switch ecgSample.classification {
                    case .notSet:
                        classification = "NotSet"
                    case .sinusRhythm:
                        classification = "SinusRhythm"
                    case .atrialFibrillation:
                        classification = "AtrialFibrillation"
                    case .inconclusiveLowHeartRate:
                        classification = "InconclusiveLowHeartRate"
                    case .inconclusiveHighHeartRate:
                        classification = "InconclusiveHighHeartRate"
                    case .inconclusivePoorReading:
                        classification = "InconclusivePoorReading"
                    case .inconclusiveOther:
                        classification = "InconclusiveOther"
                    @unknown default:
                        classification = "Unrecognized"
                    }

                    let count = HKUnit.count()
                    let minute = HKUnit.minute()
                    let bpmUnit = count.unitDivided(by: minute)
                    let averageHeartRate = ecgSample.averageHeartRate?.doubleValue(for: bpmUnit) ?? 0

                    let algorithmVersion = (ecgSample.metadata?[HKMetadataKeyAppleECGAlgorithmVersion] as? NSNumber)?.intValue ?? 0

                    let elem: [String: Any] = [
                        "id": ecgSample.uuid.uuidString,
                        "sourceName": ecgSample.sourceRevision.source.name,
                        "sourceId": ecgSample.sourceRevision.source.bundleIdentifier,
                        "startDate": startDateString,
                        "endDate": endDateString,
                        "classification": classification,
                        "averageHeartRate": averageHeartRate,
                        "samplingFrequency": ecgSample.samplingFrequency?.doubleValue(for: HKUnit.hertz()) ?? 0,
                        "device": ecgSample.sourceRevision.productType ?? "",
                        "algorithmVersion": algorithmVersion,
                        "voltageMeasurements": []
                    ]
                    let mutableElem = NSMutableDictionary(dictionary: elem)
                    data.add(mutableElem)

                    // create an array to hold the ecg voltage data which will be fetched asynchronously from healthkit
                    let voltageMeasurements = NSMutableArray(capacity: ecgSample.numberOfVoltageMeasurements)

                    // now define the data handler for the HKElectrocardiogramQuery
                    let dataHandler: (HKElectrocardiogramQuery, HKElectrocardiogram.VoltageMeasurement?, Bool, Error?) -> Void = { (voltageQuery, voltageMeasurement, done, error) in
                        if error == nil, let voltageMeasurement = voltageMeasurement {
                            // If no error exists for this data point, add the voltage measurement to the array.
                            let voltageQuantity = voltageMeasurement.quantity(for: .appleWatchSimilarToLeadI)
                            let measurement: [Any] = [
                                voltageMeasurement.timeSinceSampleStart,
                                voltageQuantity?.doubleValue(for: HKUnit.volt()) ?? 0
                            ]
                            voltageMeasurements.add(measurement)
                        }

                        if done {
                            mutableElem.setObject(voltageMeasurements, forKey: "voltageMeasurements" as NSString)
                            samplesProcessed += 1
                            maybeFinish()
                        }
                    }
                    // query the voltages for this ecg
                    let voltageQuery = HKElectrocardiogramQuery(ecgSample, dataHandler: dataHandler)
                    self.healthStore?.execute(voltageQuery)
                }
            }

            // Define and execute the HKSampleQuery
            let ecgQuery = HKSampleQuery(
                sampleType: HKObjectType.electrocardiogramType(),
                predicate: predicate,
                limit: limit,
                sortDescriptors: [timeSortDescriptor],
                resultsHandler: resultsHandler
            )
            self.healthStore?.execute(ecgQuery)
        } else {
            callback([RCTMakeError("Electrocardiogram is not available for this iOS version", nil, nil)])
        }
    }
}
