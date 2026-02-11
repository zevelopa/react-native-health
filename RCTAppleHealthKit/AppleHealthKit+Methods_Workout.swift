//
//  AppleHealthKit+Methods_Workout.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    func workout_getRoute(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let uid = AppleHealthKit.stringFromOptions(input, key: "id", withDefault: "")

        var uuid: NSUUID?

        do {
            uuid = NSUUID(uuidString: uid)
        }

        if uuid == nil {
            callback([RCTMakeError("An id is required", nil, nil)])
            return
        }

        let predicate = HKQuery.predicateForObject(with: uuid! as UUID)

        let samplesType = HKSampleType.workoutType()

        let completion: ([Any]?, Error?) -> Void = { results, error in
            if let results = results {
                // only one workout should return from the query
                for sample in results {
                    guard let workout = sample as? HKWorkout else { continue }

                    let type = HKSeriesType.workoutRoute()

                    let pre = HKQuery.predicateForObjects(from: workout)

                    let routeCompletion: (NSDictionary?, Error?) -> Void = { results, error in
                        if let results = results {
                            callback([NSNull(), results])
                            return
                        } else {
                            NSLog("error getting samples: %@", error?.localizedDescription ?? "")
                            callback([RCTMakeError("error getting samples. Activity possibly does not have a route.", error, nil)])
                            return
                        }
                    }

                    self.fetchWorkoutRoute(type,
                                           predicate: pre,
                                           anchor: nil,
                                           limit: HKObjectQueryNoLimit,
                                           completion: routeCompletion)

                    break
                }
            } else {
                NSLog("error getting samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting samples:", error, nil)])
                return
            }
        }

        self.fetchWorkoutById(samplesType,
                              unit: HKUnit.count(),
                              predicate: predicate,
                              ascending: false,
                              limit: HKObjectQueryNoLimit,
                              completion: completion)
    }

    func workout_getAnchoredQuery(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)

        let workoutType = HKObjectType.workoutType()
        let anchor = AppleHealthKit.hkAnchorFromOptions(input)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        let predicate = AppleHealthKit.predicateForAnchoredQueries(anchor, startDate: startDate, endDate: endDate)

        let completion: (NSDictionary?, Error?) -> Void = { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("error getting samples: %@", error?.localizedDescription ?? "")
                callback([RCTMakeError("error getting samples", error, nil)])
                return
            }
        }

        self.fetchAnchoredWorkouts(workoutType,
                                   predicate: predicate,
                                   anchor: anchor,
                                   limit: limit,
                                   completion: completion)
    }

    func workout_save(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let type = HKWorkoutActivityType(rawValue: AppleHealthKit.hkWorkoutActivityTypeFromOptions(input, key: "type", withDefault: HKWorkoutActivityType.americanFootball.rawValue))!
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: nil)
        let totalEnergyBurned = AppleHealthKit.hkQuantityFromOptions(input, valueKey: "energyBurned", unitKey: "energyBurnedUnit")
        let totalDistance = AppleHealthKit.hkQuantityFromOptions(input, valueKey: "distance", unitKey: "distanceUnit")

        guard let healthStore = self.healthStore, let start = startDate, let end = endDate else {
            callback([RCTMakeError("startDate and endDate are required", nil, nil)])
            return
        }

        if #available(iOS 17.0, *) {
            let config = HKWorkoutConfiguration()
            config.activityType = type

            let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: config, device: nil)
            builder.beginCollection(withStart: start) { success, error in
                guard success else {
                    callback([RCTMakeError("An error occurred saving the workout", error, nil)])
                    return
                }

                var samples = [HKSample]()

                if let energyBurned = totalEnergyBurned,
                   let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
                    let energySample = HKQuantitySample(type: energyType, quantity: energyBurned, start: start, end: end)
                    samples.append(energySample)
                }

                if let distance = totalDistance,
                   let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
                    let distanceSample = HKQuantitySample(type: distanceType, quantity: distance, start: start, end: end)
                    samples.append(distanceSample)
                }

                let addSamplesAndFinish = {
                    builder.endCollection(withEnd: end) { success, error in
                        guard success else {
                            callback([RCTMakeError("An error occurred saving the workout", error, nil)])
                            return
                        }

                        builder.finishWorkout { workout, error in
                            guard let workout = workout else {
                                callback([RCTMakeError("An error occurred saving the workout", error, nil)])
                                return
                            }
                            callback([NSNull(), workout.uuid.uuidString])
                        }
                    }
                }

                if !samples.isEmpty {
                    builder.add(samples) { success, error in
                        guard success else {
                            callback([RCTMakeError("An error occurred saving the workout", error, nil)])
                            return
                        }
                        addSamplesAndFinish()
                    }
                } else {
                    addSamplesAndFinish()
                }
            }
        } else {
            let workout = HKWorkout(activityType: type,
                                    start: start,
                                    end: end,
                                    workoutEvents: nil,
                                    totalEnergyBurned: totalEnergyBurned,
                                    totalDistance: totalDistance,
                                    metadata: nil)

            healthStore.save(workout) { success, error in
                if !success {
                    NSLog("An error occured saving the workout %@. The error was: %@.", workout, error?.localizedDescription ?? "")
                    callback([RCTMakeError("An error occured saving the workout", error, nil)])
                    return
                }
                callback([NSNull(), workout.uuid.uuidString])
            }
        }
    }
}
