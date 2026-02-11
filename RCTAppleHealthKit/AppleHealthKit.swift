//
//  AppleHealthKit.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

@objc(AppleHealthKit)
class AppleHealthKit: RCTEventEmitter {

    // MARK: - Properties

    var healthStore: HKHealthStore?
    var hasListeners: Bool = false

    // MARK: - Singleton

    private static var sharedInstance: AppleHealthKit?
    private static var sharedJsModule: RCTCallableJSModules = {
        return RCTCallableJSModules()
    }()

    override class func allocWithZone(_ zone: NSZone?) -> AnyObject {
        if sharedInstance == nil {
            sharedInstance = super.allocWithZone(zone) as? AppleHealthKit
        }
        return sharedInstance!
    }

    // MARK: - Module Setup

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    // MARK: - Initialize Health Store

    @discardableResult
    func _initializeHealthStore() -> HKHealthStore? {
        if healthStore == nil {
            healthStore = HKHealthStore()
        }
        return healthStore
    }

    // MARK: - Health Kit Availability

    func isHealthKitAvailable(_ callback: @escaping RCTResponseSenderBlock) {
        let isAvailable = HKHealthStore.isHealthDataAvailable()
        callback([NSNull(), isAvailable])
    }

    // MARK: - Initialize Health Kit

    func initializeHealthKit(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()

        if HKHealthStore.isHealthDataAvailable() {
            var writeDataTypes: Set<HKSampleType>?
            var readDataTypes: Set<HKObjectType>?

            // get permissions from input object provided by JS options argument
            if let permissions = input.object(forKey: "permissions") as? NSDictionary {
                let readPermsArray = permissions.object(forKey: "read") as? [Any] ?? []
                let writePermsArray = permissions.object(forKey: "write") as? [Any] ?? []
                let readPerms = getReadPermsFromOptions(readPermsArray)
                let writePerms = getWritePermsFromOptions(writePermsArray)

                readDataTypes = readPerms.isEmpty ? nil : readPerms
                // Convert Set<HKObjectType> to Set<HKSampleType> for write permissions
                let sampleTypes = writePerms.compactMap { $0 as? HKSampleType }
                writeDataTypes = sampleTypes.isEmpty ? nil : Set(sampleTypes)
            } else {
                callback([RCTMakeError("permissions must be provided in the initialization options", nil, nil)])
                return
            }

            // make sure at least 1 read or write permission is provided
            if writeDataTypes == nil && readDataTypes == nil {
                callback([RCTMakeError("at least 1 read or write permission must be set in options.permissions", nil, nil)])
                return
            }

            healthStore?.requestAuthorization(toShare: writeDataTypes, read: readDataTypes, completion: { (success, error) in
                if !success {
                    let errMsg = "Error with HealthKit authorization: \(String(describing: error))"
                    NSLog("%@", errMsg)
                    callback([RCTMakeError(errMsg, nil, nil)])
                    return
                } else {
                    DispatchQueue.global(qos: .default).async {
                        callback([NSNull(), true])
                    }
                }
            })
        } else {
            callback([RCTMakeError("HealthKit data is not available", nil, nil)])
        }
    }

    // MARK: - Supported Events

    override func supportedEvents() -> [String] {
        let types = [
            "ActiveEnergyBurned",
            "BasalEnergyBurned",
            "Cycling",
            "HeartRate",
            "HeartRateVariabilitySDNN",
            "RestingHeartRate",
            "Running",
            "StairClimbing",
            "StepCount",
            "Swimming",
            "Vo2Max",
            "Walking",
            "Workout",
            "MindfulSession",
            "AllergyRecord",
            "ConditionRecord",
            "CoverageRecord",
            "ImmunizationRecord",
            "LabResultRecord",
            "MedicationRecord",
            "ProcedureRecord",
            "VitalSignRecord",
            "SleepAnalysis",
            "InsulinDelivery"
        ]

        let templates = [
            "healthKit:%@:new",
            "healthKit:%@:failure",
            "healthKit:%@:enabled",
            "healthKit:%@:sample",
            "healthKit:%@:setup:success",
            "healthKit:%@:setup:failure"
        ]

        var supportedEvents = [String]()

        for type in types {
            for template in templates {
                let event = String(format: template, type)
                supportedEvents.append(event)
            }
        }
        supportedEvents.append("change:steps")
        return supportedEvents
    }

    // MARK: - Module Info

    func getModuleInfo(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let info: [String: String] = [
            "name": "react-native-apple-healthkit",
            "description": "A React Native bridge module for interacting with Apple HealthKit data",
            "className": "RCTAppleHealthKit",
            "author": "Greg Wilson"
        ]
        callback([NSNull(), info])
    }

    // MARK: - Authorization Status

    func getAuthorizationStatus(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        if HKHealthStore.isHealthDataAvailable() {
            var readPermsArray: [HKObjectType]?
            var writePermsArray: [HKObjectType]?

            if let permissions = input.object(forKey: "permissions") as? NSDictionary,
               permissions.object(forKey: "read") != nil,
               permissions.object(forKey: "write") != nil {
                let readPermsNamesArray = permissions.object(forKey: "read") as? [Any] ?? []
                let writePermsNamesArray = permissions.object(forKey: "write") as? [Any] ?? []
                readPermsArray = Array(getReadPermsFromOptions(readPermsNamesArray))
                writePermsArray = Array(getWritePermsFromOptions(writePermsNamesArray))
            } else {
                callback([RCTMakeError("permissions must be included in permissions object with read and write options", nil, nil)])
                return
            }

            var read = [NSNumber]()
            if let readPermsArray = readPermsArray {
                for perm in readPermsArray {
                    read.append(NSNumber(value: healthStore!.authorizationStatus(for: perm).rawValue))
                }
            }
            var write = [NSNumber]()
            if let writePermsArray = writePermsArray {
                for perm in writePermsArray {
                    write.append(NSNumber(value: healthStore!.authorizationStatus(for: perm).rawValue))
                }
            }
            callback([NSNull(), [
                "permissions": [
                    "read": read,
                    "write": write
                ]
            ]])
        } else {
            callback([RCTMakeError("HealthKit data is not available", nil, nil)])
        }
    }

    // MARK: - Background Observers

    func initializeBackgroundObservers(_ bridge: RCTBridge) {
        _initializeHealthStore()

        self.bridge = bridge

        if HKHealthStore.isHealthDataAvailable() {
            let fitnessObservers = [
                "ActiveEnergyBurned",
                "BasalEnergyBurned",
                "Cycling",
                "HeartRate",
                "HeartRateVariabilitySDNN",
                "RestingHeartRate",
                "Running",
                "StairClimbing",
                "StepCount",
                "Swimming",
                "Vo2Max",
                "Walking",
                "Workout",
                "MindfulSession",
                "SleepAnalysis"
            ]

            for type in fitnessObservers {
                fitness_registerObserver(type, bridge: bridge, hasListeners: hasListeners)
            }

            let clinicalObservers = [
                "AllergyRecord",
                "ConditionRecord",
                "CoverageRecord",
                "ImmunizationRecord",
                "LabResultRecord",
                "MedicationRecord",
                "ProcedureRecord",
                "VitalSignRecord"
            ]

            for type in clinicalObservers {
                clinical_registerObserver(type, bridge: bridge, hasListeners: hasListeners)
            }

            results_registerObservers(bridge, hasListeners: hasListeners)

            NSLog("[HealthKit] Background observers added to the app")
            startObserving()
        } else {
            NSLog("[HealthKit] Apple HealthKit is not available in this platform")
        }
    }

    // MARK: - Event Observing

    override func startObserving() {
        let center = NotificationCenter.default
        for notificationName in supportedEvents() {
            center.addObserver(self,
                               selector: #selector(emitEventInternal(_:)),
                               name: NSNotification.Name(notificationName),
                               object: nil)
        }
        hasListeners = true
    }

    @objc func emitEventInternal(_ notification: Notification) {
        if hasListeners {
            self.callableJSModules = AppleHealthKit.sharedJsModule
            self.callableJSModules.setBridge(self.bridge)
            sendEvent(withName: notification.name.rawValue, body: notification.userInfo)
        }
    }

    func emitEventWithName(_ name: String, andPayload payload: NSDictionary) {
        NotificationCenter.default.post(name: NSNotification.Name(name),
                                        object: self,
                                        userInfo: payload as? [AnyHashable: Any])
    }

    override func stopObserving() {
        hasListeners = false
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Exported Methods

    @objc func isAvailable(_ callback: @escaping RCTResponseSenderBlock) {
        isHealthKitAvailable(callback)
    }

    @objc func initHealthKit(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        initializeHealthKit(input, callback: callback)
    }

    @objc func initStepCountObserver(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_initializeStepEventObserver(input, hasListeners: hasListeners, callback: callback)
    }

    @objc func getBiologicalSex(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        characteristic_getBiologicalSex(input, callback: callback)
    }

    @objc func getBloodType(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        characteristic_getBloodType(input, callback: callback)
    }

    @objc func getDateOfBirth(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        characteristic_getDateOfBirth(input, callback: callback)
    }

    @objc func getLatestWeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestWeight(input, callback: callback)
    }

    @objc func getWeightSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getWeightSamples(input, callback: callback)
    }

    @objc func saveWeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveWeight(input, callback: callback)
    }

    @objc func getLatestHeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestHeight(input, callback: callback)
    }

    @objc func getHeightSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getHeightSamples(input, callback: callback)
    }

    @objc func saveHeight(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveHeight(input, callback: callback)
    }

    @objc func getLatestWaistCircumference(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestWaistCircumference(input, callback: callback)
    }

    @objc func getWaistCircumferenceSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getWaistCircumferenceSamples(input, callback: callback)
    }

    @objc func saveWaistCircumference(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveWaistCircumference(input, callback: callback)
    }

    @objc func getLatestPeakFlow(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestPeakFlow(input, callback: callback)
    }

    @objc func getPeakFlowSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getPeakFlowSamples(input, callback: callback)
    }

    @objc func savePeakFlow(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_savePeakFlow(input, callback: callback)
    }

    @objc func getLatestBmi(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestBodyMassIndex(input, callback: callback)
    }

    @objc func getBmiSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getBodyMassIndexSamples(input, callback: callback)
    }

    @objc func saveBmi(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveBodyMassIndex(input, callback: callback)
    }

    @objc func getLatestBodyFatPercentage(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestBodyFatPercentage(input, callback: callback)
    }

    @objc func getBodyFatPercentageSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getBodyFatPercentageSamples(input, callback: callback)
    }

    @objc func saveBodyFatPercentage(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveBodyFatPercentage(input, callback: callback)
    }

    @objc func saveBodyTemperature(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveBodyTemperature(input, callback: callback)
    }

    @objc func getLatestLeanBodyMass(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLatestLeanBodyMass(input, callback: callback)
    }

    @objc func getLeanBodyMassSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_getLeanBodyMassSamples(input, callback: callback)
    }

    @objc func saveLeanBodyMass(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        body_saveLeanBodyMass(input, callback: callback)
    }

    @objc func getStepCount(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getStepCountOnDay(input, callback: callback)
    }

    @objc func getSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getSamples(input, callback: callback)
    }

    @objc func getAnchoredWorkouts(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        workout_getAnchoredQuery(input, callback: callback)
    }

    @objc func getWorkoutRouteSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        workout_getRoute(input, callback: callback)
    }

    @objc func setObserver(_ input: NSDictionary) {
        _initializeHealthStore()
        fitness_setObserver(input)
    }

    @objc func getDailyStepCountSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDailyStepSamples(input, callback: callback)
    }

    @objc func saveSteps(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_saveSteps(input, callback: callback)
    }

    @objc func saveWalkingRunningDistance(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_saveWalkingRunningDistance(input, callback: callback)
    }

    @objc func getDistanceWalkingRunning(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDistanceWalkingRunningOnDay(input, callback: callback)
    }

    @objc func getDailyDistanceWalkingRunningSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDailyDistanceWalkingRunningSamples(input, callback: callback)
    }

    @objc func getDistanceCycling(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDistanceCyclingOnDay(input, callback: callback)
    }

    @objc func getDailyDistanceCyclingSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDailyDistanceCyclingSamples(input, callback: callback)
    }

    @objc func getDistanceSwimming(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDistanceSwimmingOnDay(input, callback: callback)
    }

    @objc func getDailyDistanceSwimmingSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDailyDistanceSwimmingSamples(input, callback: callback)
    }

    @objc func getFlightsClimbed(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getFlightsClimbedOnDay(input, callback: callback)
    }

    @objc func getDailyFlightsClimbedSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        fitness_getDailyFlightsClimbedSamples(input, callback: callback)
    }

    @objc func getEnergyConsumedSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        dietary_getEnergyConsumedSamples(input, callback: callback)
    }

    @objc func getProteinSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        dietary_getProteinSamples(input, callback: callback)
    }

    @objc func getFiberSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        dietary_getFiberSamples(input, callback: callback)
    }

    @objc func getTotalFatSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        dietary_getTotalFatSamples(input, callback: callback)
    }

    @objc func saveFood(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        dietary_saveFood(input, callback: callback)
    }

    @objc func saveWater(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        dietary_saveWater(input, callback: callback)
    }

    @objc func getWater(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        dietary_getWater(input, callback: callback)
    }

    @objc func saveHeartRateSample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_saveHeartRateSample(input, callback: callback)
    }

    @objc func getWaterSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        dietary_getWaterSamples(input, callback: callback)
    }

    @objc func getHeartRateSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getHeartRateSamples(input, callback: callback)
    }

    @objc func getRestingHeartRate(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getRestingHeartRate(input, callback: callback)
    }

    @objc func getWalkingHeartRateAverage(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getWalkingHeartRateAverage(input, callback: callback)
    }

    @objc func getActiveEnergyBurned(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        activity_getActiveEnergyBurned(input, callback: callback)
    }

    @objc func getBasalEnergyBurned(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        activity_getBasalEnergyBurned(input, callback: callback)
    }

    @objc func getAppleExerciseTime(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        activity_getAppleExerciseTime(input, callback: callback)
    }

    @objc func getAppleStandTime(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        activity_getAppleStandTime(input, callback: callback)
    }

    @objc func getVo2MaxSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getVo2MaxSamples(input, callback: callback)
    }

    @objc func getBodyTemperatureSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getBodyTemperatureSamples(input, callback: callback)
    }

    @objc func getBloodPressureSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getBloodPressureSamples(input, callback: callback)
    }

    @objc func getRespiratoryRateSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getRespiratoryRateSamples(input, callback: callback)
    }

    @objc func getHeartRateVariabilitySamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getHeartRateVariabilitySamples(input, callback: callback)
    }

    @objc func getHeartbeatSeriesSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getHeartbeatSeriesSamples(input, callback: callback)
    }

    @objc func getRestingHeartRateSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getRestingHeartRateSamples(input, callback: callback)
    }

    @objc func getOxygenSaturationSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getOxygenSaturationSamples(input, callback: callback)
    }

    @objc func getElectrocardiogramSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        vitals_getElectrocardiogramSamples(input, callback: callback)
    }

    @objc func getBloodGlucoseSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_getBloodGlucoseSamples(input, callback: callback)
    }

    @objc func getCarbohydratesSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_getCarbohydratesSamples(input, callback: callback)
    }

    @objc func getInsulinDeliverySamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_getInsulinDeliverySamples(input, callback: callback)
    }

    @objc func saveInsulinDeliverySample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_saveInsulinDeliverySample(input, callback: callback)
    }

    @objc func deleteInsulinDeliverySample(_ oid: String, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_deleteInsulinDeliverySample(oid, callback: callback)
    }

    @objc func saveCarbohydratesSample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_saveCarbohydratesSample(input, callback: callback)
    }

    @objc func deleteCarbohydratesSample(_ oid: String, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_deleteCarbohydratesSample(oid, callback: callback)
    }

    @objc func saveBloodGlucoseSample(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_saveBloodGlucoseSample(input, callback: callback)
    }

    @objc func deleteBloodGlucoseSample(_ oid: String, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        results_deleteBloodGlucoseSample(oid, callback: callback)
    }

    @objc func getSleepSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        sleep_getSleepSamples(input, callback: callback)
    }

    @objc func getInfo(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        getModuleInfo(input, callback: callback)
    }

    @objc func getMindfulSession(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        mindfulness_getMindfulSession(input, callback: callback)
    }

    @objc func saveMindfulSession(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        mindfulness_saveMindfulSession(input, callback: callback)
    }

    @objc func saveWorkout(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        workout_save(input, callback: callback)
    }

    @objc func getAuthStatus(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        getAuthorizationStatus(input, callback: callback)
    }

    @objc func getLatestBloodAlcoholContent(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        labTests_getLatestBloodAlcoholContent(input, callback: callback)
    }

    @objc func getBloodAlcoholContentSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        labTests_getBloodAlcoholContentSamples(input, callback: callback)
    }

    @objc func saveBloodAlcoholContent(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        labTests_saveBloodAlcoholContent(input, callback: callback)
    }

    @objc func getEnvironmentalAudioExposure(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        hearing_getEnvironmentalAudioExposure(input, callback: callback)
    }

    @objc func getHeadphoneAudioExposure(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        hearing_getHeadphoneAudioExposure(input, callback: callback)
    }

    @objc func getActivitySummary(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        summary_getActivitySummary(input, callback: callback)
    }

    @objc func getClinicalRecords(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        _initializeHealthStore()
        clinicalRecords_getClinicalRecords(input, callback: callback)
    }
}
