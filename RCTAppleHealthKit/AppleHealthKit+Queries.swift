//
//  AppleHealthKit+Queries.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit
import CoreLocation

extension AppleHealthKit {

    // MARK: - fetchWorkoutById

    func fetchWorkoutById(_ type: HKSampleType,
                          unit: HKUnit,
                          predicate: NSPredicate?,
                          ascending asc: Bool,
                          limit lim: Int,
                          completion: @escaping ([Any]?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: asc)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                if type == HKObjectType.workoutType() {
                    for sample in results {
                        guard let sample = sample as? HKWorkout else { continue }
                        do {
                            data.add(sample)
                        } catch {
                            NSLog("RNHealth: An error occured while trying to add sample from: %@ ", sample.sourceRevision.source.bundleIdentifier)
                        }
                    }
                } else {
                    NSLog("RNHealth: Must be workout type ")
                }

                completion(data as [Any], error)
            }
        }

        let query = HKSampleQuery(sampleType: type,
                                   predicate: predicate,
                                   limit: lim,
                                   sortDescriptors: [timeSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchWorkoutRoute

    func fetchWorkoutRoute(_ type: HKSampleType,
                           predicate: NSPredicate?,
                           anchor: HKQueryAnchor?,
                           limit lim: Int,
                           completion: @escaping (NSDictionary?, Error?) -> Void) {

        let handlerBlock: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, sampleObjects, deletedObjects, newAnchor, error in

            guard let sampleObjects = sampleObjects, sampleObjects.count > 0 else {
                completion(nil, error)
                return
            }

            // init store for locations
            let locations = NSMutableArray(capacity: 1)

            // only one route should return in the samples
            for routeSample in sampleObjects {
                guard let routeSample = routeSample as? HKWorkoutRoute else { continue }

                // create and assign the block to fetch locations
                let locationsHandlerBlock: (HKWorkoutRouteQuery, [CLLocation]?, Bool, Error?) -> Void = { routeQuery, routeData, done, routeError in

                    guard let routeData = routeData else {
                        // no data associated with route
                        if done {
                            // error occured
                            completion(nil, routeError)
                        }
                        return
                    }

                    // process each batch and store
                    for sample in routeData {
                        do {
                            let lat = sample.coordinate.latitude
                            let lng = sample.coordinate.longitude
                            let alt = sample.altitude
                            let timestamp = AppleHealthKit.buildISO8601StringFromDate(sample.timestamp) ?? ""

                            let elem: [String: Any] = [
                                "latitude": lat,
                                "longitude": lng,
                                "altitude": alt,
                                "timestamp": timestamp,
                                "speed": sample.speed,
                                "speedAccuracy": sample.speedAccuracy
                            ]

                            locations.add(elem)
                        } catch {
                            NSLog("RNHealth: An error occured while trying to add route sample from: %@ ", routeSample.sourceRevision.source.bundleIdentifier)
                        }
                    }

                    if done {
                        // all batches successfully completed
                        let anchorData = (try? NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)) ?? Data()
                        let anchorString = anchorData.base64EncodedString(options: [])
                        let start = AppleHealthKit.buildISO8601StringFromDate(routeSample.startDate) ?? ""
                        let end = AppleHealthKit.buildISO8601StringFromDate(routeSample.endDate) ?? ""

                        let device = routeSample.sourceRevision.productType ?? ""

                        let metaData: Any = routeSample.metadata ?? [String: Any]()

                        let routeElem: [String: Any] = [
                            "id": routeSample.uuid.uuidString,
                            "sourceId": routeSample.sourceRevision.source.bundleIdentifier,
                            "sourceName": routeSample.sourceRevision.source.name,
                            "metadata": metaData,
                            "device": device,
                            "start": start,
                            "end": end,
                            "locations": locations
                        ]

                        completion([
                            "anchor": anchorString,
                            "data": routeElem
                        ] as NSDictionary, error)
                    }
                }

                let routeQuery = HKWorkoutRouteQuery(route: routeSample, dataHandler: locationsHandlerBlock)
                self.healthStore?.execute(routeQuery)
            }
        }

        let query = HKAnchoredObjectQuery(type: type,
                                           predicate: predicate,
                                           anchor: anchor,
                                           limit: HKObjectQueryNoLimit,
                                           resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchMostRecentQuantitySampleOfType

    func fetchMostRecentQuantitySampleOfType(_ quantityType: HKQuantityType,
                                              predicate: NSPredicate?,
                                              completion: @escaping (HKQuantity?, Date?, Date?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: quantityType,
                                   predicate: predicate,
                                   limit: 1,
                                   sortDescriptors: [timeSortDescriptor]) { query, results, error in

            guard let results = results else {
                completion(nil, nil, nil, error)
                return
            }

            // If quantity isn't in the database, return nil in the completion block.
            let quantitySample = results.first as? HKQuantitySample
            let quantity = quantitySample?.quantity
            let startDate = quantitySample?.startDate
            let endDate = quantitySample?.endDate
            completion(quantity, startDate, endDate, error)
        }

        self.healthStore?.execute(query)
    }

    // MARK: - fetchQuantitySamplesOfType

    func fetchQuantitySamplesOfType(_ quantityType: HKQuantityType,
                                     unit: HKUnit,
                                     predicate: NSPredicate?,
                                     ascending asc: Bool,
                                     limit lim: Int,
                                     completion: @escaping ([Any]?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: asc)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                for sample in results {
                    guard let sample = sample as? HKQuantitySample else { continue }
                    let quantity = sample.quantity
                    let value = quantity.doubleValue(for: unit)

                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""

                    let elem = NSMutableDictionary(dictionary: [
                        "value": value,
                        "id": sample.uuid.uuidString,
                        "sourceName": sample.sourceRevision.source.name,
                        "sourceId": sample.sourceRevision.source.bundleIdentifier,
                        "startDate": startDateString,
                        "endDate": endDateString
                    ])

                    let metadata = sample.metadata
                    if let metadata = metadata {
                        elem.setValue(metadata, forKey: AppleHealthKit.kMetadataKey)
                    }

                    data.add(elem)
                }

                completion(data as [Any], error)
            }
        }

        let query = HKSampleQuery(sampleType: quantityType,
                                   predicate: predicate,
                                   limit: lim,
                                   sortDescriptors: [timeSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchSamplesOfType

    func fetchSamplesOfType(_ type: HKSampleType,
                             unit: HKUnit,
                             predicate: NSPredicate?,
                             ascending asc: Bool,
                             limit lim: Int,
                             completion: @escaping ([Any]?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: asc)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                if type == HKObjectType.workoutType() {
                    for sample in results {
                        guard let sample = sample as? HKWorkout else { continue }
                        do {
                            let energy = AppleHealthKit.workoutEnergyBurned(sample)
                            let distance = AppleHealthKit.workoutDistance(sample)
                            let activityName = AppleHealthKit.stringForHKWorkoutActivityType(Int(sample.workoutActivityType.rawValue))

                            let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? ""
                            let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""

                            var isTracked = true
                            if let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? NSNumber,
                               wasUserEntered.intValue == 1 {
                                isTracked = false
                            }

                            let device = sample.sourceRevision.productType ?? ""

                            let elem: [String: Any] = [
                                "activityId": NSNumber(value: sample.workoutActivityType.rawValue),
                                "id": sample.uuid.uuidString,
                                "activityName": activityName,
                                "calories": energy,
                                "tracked": isTracked,
                                "metadata": sample.metadata ?? NSNull(),
                                "sourceName": sample.sourceRevision.source.name,
                                "sourceId": sample.sourceRevision.source.bundleIdentifier,
                                "device": device,
                                "distance": distance,
                                "start": startDateString,
                                "end": endDateString
                            ]

                            data.add(elem)
                        } catch {
                            NSLog("RNHealth: An error occured while trying to add sample from: %@ ", sample.sourceRevision.source.bundleIdentifier)
                        }
                    }
                } else {
                    for sample in results {
                        guard let sample = sample as? HKQuantitySample else { continue }
                        do {
                            let quantity = sample.quantity
                            let value = quantity.doubleValue(for: unit)

                            var valueType = "quantity"
                            if unit == HKUnit.mile() {
                                valueType = "distance"
                            }

                            let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? ""
                            let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""

                            var isTracked = true
                            if let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? NSNumber,
                               wasUserEntered.intValue == 1 {
                                isTracked = false
                            }

                            let device = sample.sourceRevision.productType ?? ""

                            let elem: [String: Any] = [
                                valueType: value,
                                "tracked": isTracked,
                                "sourceName": sample.sourceRevision.source.name,
                                "sourceId": sample.sourceRevision.source.bundleIdentifier,
                                "device": device,
                                "start": startDateString,
                                "end": endDateString
                            ]

                            data.add(elem)
                        } catch {
                            NSLog("RNHealth: An error occured while trying to add sample from: %@ ", sample.sourceRevision.source.bundleIdentifier)
                        }
                    }
                }

                completion(data as [Any], error)
            }
        }

        let query = HKSampleQuery(sampleType: type,
                                   predicate: predicate,
                                   limit: lim,
                                   sortDescriptors: [timeSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchClinicalRecordsOfType

    func fetchClinicalRecordsOfType(_ type: HKClinicalType,
                                     predicate: NSPredicate?,
                                     ascending asc: Bool,
                                     limit lim: Int,
                                     completion: @escaping ([Any]?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: asc)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                for record in results {
                    guard let record = record as? HKClinicalRecord else { continue }

                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(record.startDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(record.endDate) ?? ""

                    var fhirData: Any?
                    do {
                        if let resourceData = record.fhirResource?.data {
                            fhirData = try JSONSerialization.jsonObject(with: resourceData, options: .mutableContainers)
                        }
                    } catch let jsonError {
                        completion(nil, jsonError)
                        return
                    }

                    guard let fhirData = fhirData else {
                        completion(nil, nil)
                        return
                    }

                    var fhirRelease: String
                    var fhirVersion: String
                    if #available(iOS 14.0, *) {
                        let fhirResourceVersion = record.fhirResource?.fhirVersion
                        fhirRelease = fhirResourceVersion?.fhirRelease ?? ""
                        fhirVersion = fhirResourceVersion?.stringRepresentation ?? ""
                    } else {
                        // iOS < 14 uses DSTU2
                        fhirRelease = "DSTU2"
                        fhirVersion = "1.0.2"
                    }

                    let elem: [String: Any] = [
                        "id": record.uuid.uuidString,
                        "sourceName": record.sourceRevision.source.name,
                        "sourceId": record.sourceRevision.source.bundleIdentifier,
                        "startDate": startDateString,
                        "endDate": endDateString,
                        "displayName": record.displayName,
                        "fhirData": fhirData,
                        "fhirRelease": fhirRelease,
                        "fhirVersion": fhirVersion
                    ]
                    data.add(elem)
                }
                completion(data as [Any], error)
            }
        }

        let query = HKSampleQuery(sampleType: type,
                                   predicate: predicate,
                                   limit: lim,
                                   sortDescriptors: [timeSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchAnchoredWorkouts

    func fetchAnchoredWorkouts(_ type: HKSampleType,
                                predicate: NSPredicate?,
                                anchor: HKQueryAnchor?,
                                limit lim: Int,
                                completion: @escaping (NSDictionary?, Error?) -> Void) {

        let handlerBlock: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, sampleObjects, deletedObjects, newAnchor, error in

            guard let sampleObjects = sampleObjects else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                for sample in sampleObjects {
                    guard let sample = sample as? HKWorkout else { continue }
                    do {
                        let energy = AppleHealthKit.workoutEnergyBurned(sample)
                        let distance = AppleHealthKit.workoutDistance(sample)
                        let activityName = AppleHealthKit.stringForHKWorkoutActivityType(Int(sample.workoutActivityType.rawValue))
                        let workoutEvents = AppleHealthKit.formatWorkoutEvents(sample.workoutEvents ?? [])
                        let duration = sample.duration

                        let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? ""
                        let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""

                        var isTracked = true
                        if let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? NSNumber,
                           wasUserEntered.intValue == 1 {
                            isTracked = false
                        }

                        let device = sample.sourceRevision.productType ?? ""

                        let elem: [String: Any] = [
                            "activityId": NSNumber(value: sample.workoutActivityType.rawValue),
                            "id": sample.uuid.uuidString,
                            "activityName": activityName,
                            "calories": energy,
                            "tracked": isTracked,
                            "metadata": sample.metadata as Any,
                            "sourceName": sample.sourceRevision.source.name,
                            "sourceId": sample.sourceRevision.source.bundleIdentifier,
                            "device": device,
                            "distance": distance,
                            "start": startDateString,
                            "end": endDateString,
                            "duration": duration,
                            "workoutEvents": workoutEvents
                        ]

                        data.add(elem)
                    } catch {
                        NSLog("RNHealth: An error occured while trying to add workout sample from: %@ ", sample.sourceRevision.source.bundleIdentifier)
                    }
                }

                let anchorData = (try? NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any, requiringSecureCoding: true)) ?? Data()
                let anchorString = anchorData.base64EncodedString(options: [])
                completion([
                    "anchor": anchorString,
                    "data": data
                ] as NSDictionary, error)
            }
        }

        let query = HKAnchoredObjectQuery(type: type,
                                           predicate: predicate,
                                           anchor: anchor,
                                           limit: lim,
                                           resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchSleepCategorySamplesForPredicate

    func fetchSleepCategorySamplesForPredicate(_ predicate: NSPredicate?,
                                                limit lim: Int,
                                                ascending asc: Bool,
                                                completion: @escaping ([Any]?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: asc)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                for sample in results {
                    guard let sample = sample as? HKCategorySample else { continue }
                    let val = sample.value

                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""

                    let valueString: String

                    switch val {
                    case HKCategoryValueSleepAnalysis.inBed.rawValue:
                        valueString = "INBED"
                    case HKCategoryValueSleepAnalysis.asleep.rawValue:
                        valueString = "ASLEEP"
                    case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                        valueString = "CORE"
                    case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                        valueString = "DEEP"
                    case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                        valueString = "REM"
                    case HKCategoryValueSleepAnalysis.awake.rawValue:
                        valueString = "AWAKE"
                    default:
                        valueString = "UNKNOWN"
                    }

                    let elem: [String: Any] = [
                        "id": sample.uuid.uuidString,
                        "value": valueString,
                        "startDate": startDateString,
                        "endDate": endDateString,
                        "sourceName": sample.sourceRevision.source.name,
                        "sourceId": sample.sourceRevision.source.bundleIdentifier
                    ]

                    data.add(elem)
                }

                completion(data as [Any], error)
            }
        }

        guard let categoryType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let query = HKSampleQuery(sampleType: categoryType,
                                   predicate: predicate,
                                   limit: lim,
                                   sortDescriptors: [timeSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchCorrelationSamplesOfType

    func fetchCorrelationSamplesOfType(_ quantityType: HKQuantityType,
                                        unit: HKUnit,
                                        predicate: NSPredicate?,
                                        ascending asc: Bool,
                                        limit lim: Int,
                                        completion: @escaping ([Any]?, Error?) -> Void) {

        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: asc)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                for sample in results {
                    guard let sample = sample as? HKCorrelation else { continue }

                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""

                    let elem: [String: Any] = [
                        "correlation": sample,
                        "startDate": startDateString,
                        "endDate": endDateString
                    ]
                    data.add(elem)
                }

                completion(data as [Any], error)
            }
        }

        let query = HKSampleQuery(sampleType: quantityType,
                                   predicate: predicate,
                                   limit: lim,
                                   sortDescriptors: [timeSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - fetchSumOfSamplesTodayForType

    func fetchSumOfSamplesTodayForType(_ quantityType: HKQuantityType,
                                        unit: HKUnit,
                                        completion completionHandler: @escaping (Double, Error?) -> Void) {

        let predicate = AppleHealthKit.predicateForSamplesToday()
        let query = HKStatisticsQuery(quantityType: quantityType,
                                       quantitySamplePredicate: predicate,
                                       options: .cumulativeSum) { query, result, error in
            let sum = result?.sumQuantity()
            let value = sum?.doubleValue(for: unit) ?? 0
            completionHandler(value, error)
        }

        self.healthStore?.execute(query)
    }

    // MARK: - fetchSumOfSamplesOnDayForType

    func fetchSumOfSamplesOnDayForType(_ quantityType: HKQuantityType,
                                        unit: HKUnit,
                                        includeManuallyAdded: Bool,
                                        day: Date,
                                        completion completionHandler: @escaping (Double, Date?, Date?, Error?) -> Void) {

        let dayPredicate = AppleHealthKit.predicateForSamplesOnDay(day)
        var predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate])
        if includeManuallyAdded == false {
            let manualDataPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, manualDataPredicate])
        }

        let query = HKStatisticsQuery(quantityType: quantityType,
                                       quantitySamplePredicate: predicate,
                                       options: .cumulativeSum) { query, result, error in

            if error?.localizedDescription == "No data available for the specified predicate." {
                completionHandler(0, day, day, nil)
            } else {
                let sum = result?.sumQuantity()
                let startDate = result?.startDate
                let endDate = result?.endDate
                let value = sum?.doubleValue(for: unit) ?? 0

                var returnError = error
                if startDate == nil || endDate == nil {
                    returnError = NSError(domain: "AppleHealthKit",
                                          code: 0,
                                          userInfo: ["Error reason": "Could not fetch statistics: Not authorized"])
                }
                completionHandler(value, startDate, endDate, returnError)
            }
        }

        self.healthStore?.execute(query)
    }

    // MARK: - fetchCumulativeSumStatisticsCollection (3-param: startDate, endDate)

    func fetchCumulativeSumStatisticsCollection(_ quantityType: HKQuantityType,
                                                 unit: HKUnit,
                                                 startDate: Date,
                                                 endDate: Date,
                                                 completion completionHandler: @escaping ([Any]?, Error?) -> Void) {

        let calendar = Calendar.current
        var interval = DateComponents()
        interval.day = 1

        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)!

        let predicate = NSPredicate(format: "metadata.%K != YES AND %K >= %@ AND %K <= %@",
                                    HKMetadataKeyWasUserEntered,
                                    HKPredicateKeyPathEndDate, startDate as NSDate,
                                    HKPredicateKeyPathStartDate, endDate as NSDate)

        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                 quantitySamplePredicate: predicate,
                                                 options: .cumulativeSum,
                                                 anchorDate: anchorDate,
                                                 intervalComponents: interval)

        // Set the results handler
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                // Perform proper error handling here
                NSLog("*** An error occurred while calculating the statistics: %@ ***", error.localizedDescription)
            }

            let data = NSMutableArray(capacity: 1)
            results?.enumerateStatistics(from: startDate, to: endDate) { result, stop in
                if let quantity = result.sumQuantity() {
                    let date = result.startDate
                    let value = quantity.doubleValue(for: HKUnit.count())
                    NSLog("%@: %f", date as NSDate, value)

                    let dateString = AppleHealthKit.buildISO8601StringFromDate(date) ?? ""
                    let elem: [Any] = [dateString, value]
                    data.add(elem)
                }
            }
            let err: Error? = nil
            completionHandler(data as [Any], err)
        }

        self.healthStore?.execute(query)
    }

    // MARK: - fetchCumulativeSumStatisticsCollection (5-param: + ascending, limit)

    func fetchCumulativeSumStatisticsCollection(_ quantityType: HKQuantityType,
                                                 unit: HKUnit,
                                                 startDate: Date,
                                                 endDate: Date,
                                                 ascending asc: Bool,
                                                 limit lim: Int,
                                                 completion completionHandler: @escaping ([Any]?, Error?) -> Void) {

        let calendar = Calendar.current
        var interval = DateComponents()
        interval.day = 1

        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)!

        let predicate = NSPredicate(format: "metadata.%K != YES AND %K >= %@ AND %K <= %@",
                                    HKMetadataKeyWasUserEntered,
                                    HKPredicateKeyPathEndDate, startDate as NSDate,
                                    HKPredicateKeyPathStartDate, endDate as NSDate)

        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                 quantitySamplePredicate: predicate,
                                                 options: .cumulativeSum,
                                                 anchorDate: anchorDate,
                                                 intervalComponents: interval)

        // Set the results handler
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                // Perform proper error handling here
                NSLog("*** An error occurred while calculating the statistics: %@ ***", error.localizedDescription)
            }

            let data = NSMutableArray(capacity: 1)

            results?.enumerateStatistics(from: startDate, to: endDate) { result, stop in
                if let quantity = result.sumQuantity() {
                    let resultStartDate = result.startDate
                    let resultEndDate = result.endDate
                    let value = quantity.doubleValue(for: unit)

                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(resultStartDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(resultEndDate) ?? ""

                    let elem: [String: Any] = [
                        "value": value,
                        "startDate": startDateString,
                        "endDate": endDateString
                    ]
                    data.add(elem)
                }
            }

            // is ascending by default
            if asc == false {
                _ = AppleHealthKit.reverseNSMutableArray(data)
            }

            if lim > 0 && data.count > lim {
                let slicedArray = data.subarray(with: NSRange(location: 0, length: lim))
                let err: Error? = nil
                completionHandler(slicedArray, err)
            } else {
                let err: Error? = nil
                completionHandler(data as [Any], err)
            }
        }

        self.healthStore?.execute(query)
    }

    // MARK: - fetchCumulativeSumStatisticsCollection (8-param: + period, includeManuallyAdded)

    func fetchCumulativeSumStatisticsCollection(_ quantityType: HKQuantityType,
                                                 unit: HKUnit,
                                                 period: Int,
                                                 startDate: Date,
                                                 endDate: Date,
                                                 ascending asc: Bool,
                                                 limit lim: Int,
                                                 includeManuallyAdded: Bool,
                                                 completion completionHandler: @escaping ([Any]?, Error?) -> Void) {

        let calendar = Calendar.current
        var interval = DateComponents()
        interval.minute = period

        let anchorComponents = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: startDate)
        let anchorDate = calendar.date(from: anchorComponents)!

        var predicate: NSPredicate
        if includeManuallyAdded == false {
            predicate = NSPredicate(format: "metadata.%K != YES AND %K >= %@ AND %K <= %@",
                                    HKMetadataKeyWasUserEntered,
                                    HKPredicateKeyPathEndDate, startDate as NSDate,
                                    HKPredicateKeyPathStartDate, endDate as NSDate)
        } else {
            predicate = NSPredicate(format: "%K >= %@ AND %K <= %@",
                                    HKPredicateKeyPathEndDate, startDate as NSDate,
                                    HKPredicateKeyPathStartDate, endDate as NSDate)
        }

        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                 quantitySamplePredicate: predicate,
                                                 options: [.cumulativeSum, .separateBySource],
                                                 anchorDate: anchorDate,
                                                 intervalComponents: interval)

        // Set the results handler
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                // Perform proper error handling here
                NSLog("*** An error occurred while calculating the statistics: %@ ***", error.localizedDescription)
            }

            let data = NSMutableArray(capacity: 1)

            results?.enumerateStatistics(from: startDate, to: endDate) { result, stop in
                if let quantity = result.sumQuantity() {
                    let resultStartDate = result.startDate
                    let resultEndDate = result.endDate
                    let value = quantity.doubleValue(for: unit)

                    let startDateString = AppleHealthKit.buildISO8601StringFromDate(resultStartDate) ?? ""
                    let endDateString = AppleHealthKit.buildISO8601StringFromDate(resultEndDate) ?? ""

                    let metadata = NSMutableArray(capacity: 1)

                    if let sources = result.sources {
                        for source in sources {
                            let bundleIdentifier = source.bundleIdentifier
                            let name = source.name
                            let sourceQuantity = result.sumQuantity(for: source)
                            let sourceValue = sourceQuantity?.doubleValue(for: unit) ?? 0

                            if sourceValue != 0 {
                                let sourceItem: [String: Any] = [
                                    "sourceId": bundleIdentifier,
                                    "sourceName": name,
                                    "quantity": sourceValue
                                ]
                                metadata.add(sourceItem)
                            }
                        }
                    }

                    let elem: [String: Any] = [
                        "value": value,
                        "startDate": startDateString,
                        "endDate": endDateString,
                        "metadata": metadata
                    ]
                    data.add(elem)
                }
            }

            // is ascending by default
            if asc == false {
                _ = AppleHealthKit.reverseNSMutableArray(data)
            }

            if lim > 0 && data.count > lim {
                let slicedArray = data.subarray(with: NSRange(location: 0, length: lim))
                let err: Error? = nil
                completionHandler(slicedArray, err)
            } else {
                let err: Error? = nil
                completionHandler(data as [Any], err)
            }
        }

        self.healthStore?.execute(query)
    }

    // MARK: - fetchWorkoutForPredicate

    func fetchWorkoutForPredicate(_ predicate: NSPredicate?,
                                   ascending: Bool,
                                   limit: Int,
                                   completion: @escaping ([Any]?, Error?) -> Void) {

        let endDateSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: ascending)

        let handlerBlock: (HKSampleQuery, [HKSample]?, Error?) -> Void = { query, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)
            let numberToWorkoutNameDictionary = AppleHealthKit.getNumberToWorkoutNameDictionary()

            DispatchQueue.global().async {
                for sample in results {
                    guard let sample = sample as? HKWorkout else { continue }
                    let energy = AppleHealthKit.workoutEnergyBurned(sample)
                    let distance = AppleHealthKit.workoutDistance(sample)
                    let activityNumber = NSNumber(value: sample.workoutActivityType.rawValue)

                    let activityName = numberToWorkoutNameDictionary.object(forKey: activityNumber) as? String

                    if let activityName = activityName {
                        let elem: [String: Any] = [
                            "activityName": activityName,
                            "calories": energy,
                            "distance": distance,
                            "startDate": AppleHealthKit.buildISO8601StringFromDate(sample.startDate) ?? "",
                            "endDate": AppleHealthKit.buildISO8601StringFromDate(sample.endDate) ?? ""
                        ]
                        data.add(elem)
                    }
                }
                completion(data as [Any], error)
            }
        }

        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                   predicate: predicate,
                                   limit: limit,
                                   sortDescriptors: [endDateSortDescriptor],
                                   resultsHandler: handlerBlock)

        self.healthStore?.execute(query)
    }

    // MARK: - setObserverForType (DEPRECATED)

    @available(*, deprecated, message: "Use setObserverForType(_:type:bridge:hasListeners:) instead")
    func setObserverForType(_ sampleType: HKSampleType, type: String) {

        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { [weak self] query, completionHandler, error in
            NSLog("[HealthKit] New sample received from Apple HealthKit - %@", type)

            let successEvent = String(format: "healthKit:%@:sample", type)

            if let error = error {
                completionHandler()

                NSLog("[HealthKit] An error happened when receiving a new sample - %@", error.localizedDescription)

                return
            }

            NSLog("Emitting event: %@", successEvent)
            self?.emitEventWithName(successEvent, andPayload: [:])

            completionHandler()

            NSLog("[HealthKit] New sample from Apple HealthKit processed (dep) - %@ %@", type, successEvent)
        }

        self.healthStore?.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { [weak self] success, error in
            let successEvent = String(format: "healthKit:%@:enabled", type)

            if let error = error {
                NSLog("[HealthKit] An error happened when setting up background observer - %@", error.localizedDescription)

                return
            }

            self?.healthStore?.execute(query)

            self?.emitEventWithName(successEvent, andPayload: [:])
        }
    }

    // MARK: - setObserverForType (with bridge and hasListeners)

    func setObserverForType(_ sampleType: HKSampleType,
                             type: String,
                             bridge: RCTBridge,
                             hasListeners: Bool) {

        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { [weak self] query, completionHandler, error in
            NSLog("[HealthKit] New sample received from Apple HealthKit - %@", type)

            let successEvent = String(format: "healthKit:%@:new", type)
            let failureEvent = String(format: "healthKit:%@:failure", type)

            if let error = error {
                completionHandler()

                NSLog("[HealthKit] An error happened when receiving a new sample - %@", error.localizedDescription)
                if self?.hasListeners == true {
                    self?.emitEventWithName(failureEvent, andPayload: [:])
                }
                return
            }

            if self?.hasListeners == true {
                self?.emitEventWithName(successEvent, andPayload: [:])
            } else {
                NSLog("There is no listeners for %@", successEvent)
            }
            completionHandler()

            NSLog("[HealthKit] New sample from Apple HealthKit processed - %@ %@", type, successEvent)
        }

        self.healthStore?.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { [weak self] success, error in
            let successEvent = String(format: "healthKit:%@:setup:success", type)
            let failureEvent = String(format: "healthKit:%@:setup:failure", type)

            if let error = error {
                NSLog("[HealthKit] An error happened when setting up background observer - %@", error.localizedDescription)
                if self?.hasListeners == true {
                    self?.emitEventWithName(failureEvent, andPayload: [:])
                }
                return
            }
            NSLog("[HealthKit] Background delivery enabled for %@", type)
            self?.healthStore?.execute(query)
            if self?.hasListeners == true {
                NSLog("[HealthKit] Background observer set up for %@", type)
                self?.emitEventWithName(successEvent, andPayload: [:])
            }
        }
    }

    // MARK: - fetchActivitySummary

    func fetchActivitySummary(_ startDate: Date,
                               endDate: Date,
                               completion completionHandler: @escaping ([Any]?, Error?) -> Void) {

        let calendar = Calendar.current
        var startComponent = calendar.dateComponents([.day, .month, .year, .era], from: startDate)
        startComponent.calendar = calendar
        var endComponent = calendar.dateComponents([.day, .month, .year, .era], from: endDate)
        endComponent.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: startComponent, end: endComponent)

        let query = HKActivitySummaryQuery(predicate: predicate) { query, results, error in
            if let error = error {
                // Perform proper error handling here
                NSLog("*** An error occurred while fetching the summary: %@ ***", error.localizedDescription)
                completionHandler(nil, error)
                return
            }

            let data = NSMutableArray(capacity: 1)

            DispatchQueue.global().async {
                guard let results = results else {
                    completionHandler(data as [Any], error)
                    return
                }

                for summary in results {
                    let aebVal = Int(summary.activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()))
                    let aebgVal = Int(summary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie()))
                    let aetVal = Int(summary.appleExerciseTime.doubleValue(for: HKUnit.minute()))
                    let aetgVal = Int(summary.appleExerciseTimeGoal.doubleValue(for: HKUnit.minute()))
                    let ashVal = Int(summary.appleStandHours.doubleValue(for: HKUnit.count()))
                    let ashgVal = Int(summary.appleStandHoursGoal.doubleValue(for: HKUnit.count()))

                    let elem: [String: Any] = [
                        "activeEnergyBurned": aebVal,
                        "activeEnergyBurnedGoal": aebgVal,
                        "appleExerciseTime": aetVal,
                        "appleExerciseTimeGoal": aetgVal,
                        "appleStandHours": ashVal,
                        "appleStandHoursGoal": ashgVal
                    ]

                    data.add(elem)
                }

                completionHandler(data as [Any], error)
            }
        }

        self.healthStore?.execute(query)
    }
}
