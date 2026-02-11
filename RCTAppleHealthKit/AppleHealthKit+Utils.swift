//
//  AppleHealthKit+Utils.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    static let kMetadataKey = "metadata"

    // MARK: - Utilities

    @objc static func formatWorkoutEvents(_ workoutEvents: [Any]) -> [Any] {
        var formattedWorkEvents: [Any] = []

        for workoutEvent in workoutEvents {
            guard let event = workoutEvent as? HKWorkoutEvent else { continue }
            let eventType = event.type
            var eventDescription = ""

            switch eventType {
            case .pause:
                eventDescription = "pause"
            case .resume:
                eventDescription = "resume"
            case .motionPaused:
                eventDescription = "motion paused"
            case .motionResumed:
                eventDescription = "motion resumed"
            case .pauseOrResumeRequest:
                eventDescription = "pause or resume request"
            case .lap:
                eventDescription = "lap"
            case .segment:
                eventDescription = "segment"
            case .marker:
                eventDescription = ""
            @unknown default:
                eventDescription = ""
            }

            let formattedEvent: [String: Any] = [
                "eventTypeInt": NSNumber(value: eventType.rawValue),
                "eventType": eventDescription,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(event.dateInterval.start) ?? "",
                "endDate": AppleHealthKit.buildISO8601StringFromDate(event.dateInterval.end) ?? ""
            ]
            formattedWorkEvents.append(formattedEvent)
        }

        return formattedWorkEvents
    }

    @objc static func parseISO8601DateFromString(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        let posix = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = posix
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
        return dateFormatter.date(from: date)
    }

    @objc static func buildISO8601StringFromDate(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        let posix = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = posix
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
        return dateFormatter.string(from: date)
    }

    @objc static func predicateForSamplesToday() -> NSPredicate {
        let now = Date()
        return AppleHealthKit.predicateForSamplesOnDay(now)
    }

    @objc static func predicateForSamplesOnDayFromTimestamp(_ timestamp: String) -> NSPredicate {
        let day = AppleHealthKit.parseISO8601DateFromString(timestamp) ?? Date()
        return AppleHealthKit.predicateForSamplesOnDay(day)
    }

    @objc static func predicateForSamplesOnDay(_ date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    }

    @objc static func predicateForSamplesBetweenDates(_ startDate: Date, endDate: Date) -> NSPredicate {
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    }

    @objc static func predicateForAnchoredQueries(_ anchor: HKQueryAnchor?, startDate: Date?, endDate: Date?) -> NSPredicate? {
        if startDate == nil {
            return nil
        } else {
            return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        }
    }

    @objc static func doubleValueFromOptions(_ options: NSDictionary) -> Double {
        let value = (options.object(forKey: "value") as? NSNumber)?.doubleValue ?? 0
        return value
    }

    @objc static func dateFromOptions(_ options: NSDictionary) -> Date? {
        let dateString = options.object(forKey: "date") as? String
        var date: Date?
        if dateString != nil {
            date = AppleHealthKit.parseISO8601DateFromString(dateString!)
        }
        return date
    }

    @objc static func dateFromOptionsDefaultNow(_ options: NSDictionary) -> Date {
        let dateString = options.object(forKey: "date") as? String
        if dateString != nil {
            var date = AppleHealthKit.parseISO8601DateFromString(dateString!)
            if date == nil {
                // probably not a good idea... should return an error or just the null pointer
                date = Date()
            }
            return date!
        }
        let now = Date()
        return now
    }

    @objc static func startDateFromOptions(_ options: NSDictionary) -> Date? {
        let dateString = options.object(forKey: "startDate") as? String
        var date: Date?
        if dateString != nil {
            date = AppleHealthKit.parseISO8601DateFromString(dateString!)
            return date
        }
        return date
    }

    @objc static func endDateFromOptions(_ options: NSDictionary) -> Date? {
        let dateString = options.object(forKey: "endDate") as? String
        var date: Date?
        if dateString != nil {
            date = AppleHealthKit.parseISO8601DateFromString(dateString!)
        }
        return date
    }

    @objc static func endDateFromOptionsDefaultNow(_ options: NSDictionary) -> Date {
        let dateString = options.object(forKey: "endDate") as? String
        var date: Date?
        if dateString != nil {
            date = AppleHealthKit.parseISO8601DateFromString(dateString!)
            return date!
        }
        if date == nil {
            date = Date()
        }
        return date!
    }

    /// Convert Human Readable name for a HealthKit activity into a HKObjectType format
    ///
    /// - Parameter type: The human readable format
    @objc static func quantityTypeFromName(_ type: String) -> HKSampleType {
        if type == "ActiveEnergyBurned" {
            return HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        } else if type == "BasalEnergyBurned" {
            return HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        } else if type == "Cycling" {
            return HKObjectType.quantityType(forIdentifier: .distanceCycling)!
        } else if type == "HeartRate" {
            return HKObjectType.quantityType(forIdentifier: .heartRate)!
        } else if type == "HeartRateVariabilitySDNN" {
            return HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        } else if type == "RestingHeartRate" {
            return HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        } else if type == "Running" {
            return HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        } else if type == "StairClimbing" {
            return HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
        } else if type == "StepCount" {
            return HKObjectType.quantityType(forIdentifier: .stepCount)!
        } else if type == "Swimming" {
            return HKObjectType.quantityType(forIdentifier: .distanceSwimming)!
        } else if type == "Vo2Max" {
            return HKObjectType.quantityType(forIdentifier: .vo2Max)!
        } else if type == "Walking" {
            return HKObjectType.quantityType(forIdentifier: .stepCount)!
        } else if type == "Workout" {
            return HKObjectType.workoutType()
        }

        return HKObjectType.workoutType()
    }

    @objc static func clinicalTypeFromName(_ type: String) -> HKSampleType? {
        if type == "AllergyRecord" {
            return HKObjectType.clinicalType(forIdentifier: .allergyRecord)
        } else if type == "ConditionRecord" {
            return HKObjectType.clinicalType(forIdentifier: .conditionRecord)
        } else if type == "ImmunizationRecord" {
            return HKObjectType.clinicalType(forIdentifier: .immunizationRecord)
        } else if type == "LabResultRecord" {
            return HKObjectType.clinicalType(forIdentifier: .labResultRecord)
        } else if type == "MedicationRecord" {
            return HKObjectType.clinicalType(forIdentifier: .medicationRecord)
        } else if type == "ProcedureRecord" {
            return HKObjectType.clinicalType(forIdentifier: .procedureRecord)
        } else if type == "VitalSignRecord" {
            return HKObjectType.clinicalType(forIdentifier: .vitalSignRecord)
        }

        if #available(iOS 14.0, *) {
            if type == "CoverageRecord" {
                return HKObjectType.clinicalType(forIdentifier: .coverageRecord)
            }
        }

        return nil
    }

    @objc static func hkAnchorFromOptions(_ options: NSDictionary) -> HKQueryAnchor? {
        guard let anchorString = options.object(forKey: "anchor") as? String, !anchorString.isEmpty else {
            return nil
        }
        guard let anchorData = Data(base64Encoded: anchorString, options: []) else {
            return nil
        }
        let anchor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: anchorData)
        return anchor
    }

    @objc static func hkUnitFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: HKUnit) -> HKUnit {
        let unitString = options.object(forKey: key) as? String
        var theUnit: HKUnit?

        if unitString == "gram" {
            theUnit = HKUnit.gram()
        }
        if unitString == "kg" {
            theUnit = HKUnit.gramUnit(with: .kilo)
        }
        if unitString == "stone" {
            theUnit = HKUnit.stone()
        }
        if unitString == "pound" {
            theUnit = HKUnit.pound()
        }
        if unitString == "meter" {
            theUnit = HKUnit.meter()
        }
        if unitString == "cm" {
            theUnit = HKUnit.meterUnit(with: .centi)
        }
        if unitString == "inch" {
            theUnit = HKUnit.inch()
        }
        if unitString == "mile" {
            theUnit = HKUnit.mile()
        }
        if unitString == "foot" {
            theUnit = HKUnit.foot()
        }
        if unitString == "second" {
            theUnit = HKUnit.second()
        }
        if unitString == "minute" {
            theUnit = HKUnit.minute()
        }
        if unitString == "hour" {
            theUnit = HKUnit.hour()
        }
        if unitString == "day" {
            theUnit = HKUnit.day()
        }
        if unitString == "joule" {
            theUnit = HKUnit.joule()
        }
        if unitString == "calorie" {
            theUnit = HKUnit.calorie()
        }
        if unitString == "count" {
            theUnit = HKUnit.count()
        }
        if unitString == "percent" {
            theUnit = HKUnit.percent()
        }
        if unitString == "bpm" {
            let count = HKUnit.count()
            let minute = HKUnit.minute()
            theUnit = count.unitDivided(by: minute)
        }
        if unitString == "fahrenheit" {
            theUnit = HKUnit.degreeFahrenheit()
        }
        if unitString == "celsius" {
            theUnit = HKUnit.degreeCelsius()
        }
        if unitString == "mmhg" {
            theUnit = HKUnit.millimeterOfMercury()
        }
        if unitString == "mmolPerL" {
            theUnit = HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())
        }
        if unitString == "literPerMinute" {
            theUnit = HKUnit.liter().unitDivided(by: HKUnit.minute())
        }
        if unitString == "mgPerdL" {
            theUnit = HKUnit(from: "mg/dL")
        }
        if unitString == "mlPerKgMin" {
            let ml = HKUnit.literUnit(with: .milli)
            let kg = HKUnit.gramUnit(with: .kilo)
            let min = HKUnit.minute()
            theUnit = ml.unitDivided(by: kg.unitMultiplied(by: min))
        }

        if theUnit == nil {
            theUnit = defaultValue
        }

        return theUnit!
    }

    @objc static func uintFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: Int) -> Int {
        var val: Int
        let num = options.object(forKey: key) as? NSNumber
        if num != nil {
            val = num!.intValue
        } else {
            val = defaultValue
        }
        return val
    }

    @objc static func doubleFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: Double) -> Double {
        var val: Double
        let num = options.object(forKey: key) as? NSNumber
        if num != nil {
            val = num!.doubleValue
        } else {
            val = defaultValue
        }
        return val
    }

    @objc static func dateFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: Date?) -> Date? {
        let dateString = options.object(forKey: key) as? String
        var date: Date?
        if dateString != nil {
            date = AppleHealthKit.parseISO8601DateFromString(dateString!)
        } else {
            date = defaultValue
        }
        return date
    }

    @objc static func stringFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: String) -> String {
        var str = options.object(forKey: key) as? String
        if str == nil {
            str = defaultValue
        }
        return str!
    }

    @objc static func boolFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: Bool) -> Bool {
        let num = options.object(forKey: key) as? NSNumber
        if num == nil {
            return defaultValue
        }
        return num!.boolValue
    }

    @objc static func metadataFromOptions(_ options: NSDictionary, withDefault defaultValue: NSDictionary?) -> NSDictionary? {
        let metadata = options.object(forKey: AppleHealthKit.kMetadataKey) as? NSDictionary
        if metadata == nil {
            return defaultValue
        }
        return metadata
    }

    @objc static func reverseNSMutableArray(_ array: NSMutableArray) -> NSMutableArray {
        if array.count <= 1 {
            return array
        }
        var i: Int = 0
        var j: Int = array.count - 1
        while i < j {
            array.exchangeObject(at: i, withObjectAt: j)
            i += 1
            j -= 1
        }
        return array
    }

    @objc static func hkWorkoutActivityTypeFromOptions(_ options: NSDictionary, key: String, withDefault defaultValue: UInt) -> UInt {
        let stringToWorkoutActivityType = AppleHealthKit.getStringToWorkoutActivityTypeDictionary()
        var activityType = defaultValue

        if let activityString = options.object(forKey: key) as? String,
           let workoutType = stringToWorkoutActivityType[activityString] {
            activityType = workoutType.rawValue
        }
        return activityType
    }

    @objc static func hkQuantityFromOptions(_ options: NSDictionary, valueKey: String, unitKey: String) -> HKQuantity? {
        let outOfBoundValue: Double = -1
        let value = AppleHealthKit.doubleFromOptions(options, key: valueKey, withDefault: outOfBoundValue)
        let unit = AppleHealthKit.hkUnitFromOptions(options, key: unitKey, withDefault: nil)

        if let unit = unit, value >= 0 {
            return HKQuantity(unit: unit, doubleValue: value)
        }
        return nil
    }

    // MARK: - Workout Helpers (iOS 16+ deprecation-safe)

    static func workoutEnergyBurned(_ workout: HKWorkout) -> Double {
        if #available(iOS 16.0, *) {
            guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return 0 }
            return workout.statistics(for: energyType)?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
        } else {
            return workout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
        }
    }

    static func workoutDistance(_ workout: HKWorkout) -> Double {
        if #available(iOS 16.0, *) {
            guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return 0 }
            return workout.statistics(for: distanceType)?.sumQuantity()?.doubleValue(for: HKUnit.mile()) ?? 0
        } else {
            return workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0
        }
    }

    @objc static func stringForHKWorkoutActivityType(_ enumValue: Int) -> String {
        switch enumValue {
        case HKWorkoutActivityType.americanFootball.rawValue:
            return "AmericanFootball"
        case HKWorkoutActivityType.archery.rawValue:
            return "Archery"
        case HKWorkoutActivityType.australianFootball.rawValue:
            return "AustralianFootball"
        case HKWorkoutActivityType.badminton.rawValue:
            return "Badminton"
        case HKWorkoutActivityType.baseball.rawValue:
            return "Baseball"
        case HKWorkoutActivityType.basketball.rawValue:
            return "Basketball"
        case HKWorkoutActivityType.bowling.rawValue:
            return "Bowling"
        case HKWorkoutActivityType.boxing.rawValue:
            return "Boxing"
        case HKWorkoutActivityType.cardioDance.rawValue:
            return "CardioDance"
        case HKWorkoutActivityType.climbing.rawValue:
            return "Climbing"
        case HKWorkoutActivityType.cooldown.rawValue:
            return "Cooldown"
        case HKWorkoutActivityType.cricket.rawValue:
            return "Cricket"
        case HKWorkoutActivityType.crossTraining.rawValue:
            return "CrossTraining"
        case HKWorkoutActivityType.curling.rawValue:
            return "Curling"
        case HKWorkoutActivityType.cycling.rawValue:
            return "Cycling"
        case HKWorkoutActivityType.dance.rawValue:
            return "Dance"
        case HKWorkoutActivityType.discSports.rawValue:
            return "DiscSports"
        case HKWorkoutActivityType.elliptical.rawValue:
            return "Elliptical"
        case HKWorkoutActivityType.equestrianSports.rawValue:
            return "EquestrianSports"
        case HKWorkoutActivityType.fencing.rawValue:
            return "Fencing"
        case HKWorkoutActivityType.fitnessGaming.rawValue:
            return "FitnessGaming"
        case HKWorkoutActivityType.fishing.rawValue:
            return "Fishing"
        case HKWorkoutActivityType.functionalStrengthTraining.rawValue:
            return "FunctionalStrengthTraining"
        case HKWorkoutActivityType.golf.rawValue:
            return "Golf"
        case HKWorkoutActivityType.gymnastics.rawValue:
            return "Gymnastics"
        case HKWorkoutActivityType.handball.rawValue:
            return "Handball"
        case HKWorkoutActivityType.hiking.rawValue:
            return "Hiking"
        case HKWorkoutActivityType.hockey.rawValue:
            return "Hockey"
        case HKWorkoutActivityType.hunting.rawValue:
            return "Hunting"
        case HKWorkoutActivityType.lacrosse.rawValue:
            return "Lacrosse"
        case HKWorkoutActivityType.martialArts.rawValue:
            return "MartialArts"
        case HKWorkoutActivityType.mindAndBody.rawValue:
            return "MindAndBody"
        case HKWorkoutActivityType.mixedCardio.rawValue:
            return "MixedCardio"
        case HKWorkoutActivityType.paddleSports.rawValue:
            return "PaddleSports"
        case HKWorkoutActivityType.play.rawValue:
            return "Play"
        case HKWorkoutActivityType.pickleball.rawValue:
            return "Pickleball"
        case HKWorkoutActivityType.preparationAndRecovery.rawValue:
            return "PreparationAndRecovery"
        case HKWorkoutActivityType.racquetball.rawValue:
            return "Racquetball"
        case HKWorkoutActivityType.rowing.rawValue:
            return "Rowing"
        case HKWorkoutActivityType.rugby.rawValue:
            return "Rugby"
        case HKWorkoutActivityType.running.rawValue:
            return "Running"
        case HKWorkoutActivityType.sailing.rawValue:
            return "Sailing"
        case HKWorkoutActivityType.skatingSports.rawValue:
            return "SkatingSports"
        case HKWorkoutActivityType.snowSports.rawValue:
            return "SnowSports"
        case HKWorkoutActivityType.soccer.rawValue:
            return "Soccer"
        case HKWorkoutActivityType.socialDance.rawValue:
            return "SocialDance"
        case HKWorkoutActivityType.softball.rawValue:
            return "Softball"
        case HKWorkoutActivityType.squash.rawValue:
            return "Squash"
        case HKWorkoutActivityType.stairClimbing.rawValue:
            return "StairClimbing"
        case HKWorkoutActivityType.surfingSports.rawValue:
            return "SurfingSports"
        case HKWorkoutActivityType.swimming.rawValue:
            return "Swimming"
        case HKWorkoutActivityType.tableTennis.rawValue:
            return "TableTennis"
        case HKWorkoutActivityType.tennis.rawValue:
            return "Tennis"
        case HKWorkoutActivityType.trackAndField.rawValue:
            return "TrackAndField"
        case HKWorkoutActivityType.traditionalStrengthTraining.rawValue:
            return "TraditionalStrengthTraining"
        case HKWorkoutActivityType.volleyball.rawValue:
            return "Volleyball"
        case HKWorkoutActivityType.walking.rawValue:
            return "Walking"
        case HKWorkoutActivityType.waterFitness.rawValue:
            return "WaterFitness"
        case HKWorkoutActivityType.waterPolo.rawValue:
            return "WaterPolo"
        case HKWorkoutActivityType.waterSports.rawValue:
            return "WaterSports"
        case HKWorkoutActivityType.wrestling.rawValue:
            return "Wrestling"
        case HKWorkoutActivityType.yoga.rawValue:
            return "Yoga"
        case HKWorkoutActivityType.other.rawValue:
            return "Other"
        case HKWorkoutActivityType.barre.rawValue:
            return "Barre"
        case HKWorkoutActivityType.coreTraining.rawValue:
            return "CoreTraining"
        case HKWorkoutActivityType.crossCountrySkiing.rawValue:
            return "CrossCountrySkiing"
        case HKWorkoutActivityType.downhillSkiing.rawValue:
            return "DownhillSkiing"
        case HKWorkoutActivityType.flexibility.rawValue:
            return "Flexibility"
        case HKWorkoutActivityType.highIntensityIntervalTraining.rawValue:
            return "HighIntensityIntervalTraining"
        case HKWorkoutActivityType.jumpRope.rawValue:
            return "JumpRope"
        case HKWorkoutActivityType.kickboxing.rawValue:
            return "Kickboxing"
        case HKWorkoutActivityType.pilates.rawValue:
            return "Pilates"
        case HKWorkoutActivityType.snowboarding.rawValue:
            return "Snowboarding"
        case HKWorkoutActivityType.stairs.rawValue:
            return "Stairs"
        case HKWorkoutActivityType.stepTraining.rawValue:
            return "StepTraining"
        case HKWorkoutActivityType.wheelchairWalkPace.rawValue:
            return "WheelchairWalkPace"
        case HKWorkoutActivityType.wheelchairRunPace.rawValue:
            return "WheelchairRunPace"
        case HKWorkoutActivityType.taiChi.rawValue:
            return "TaiChi"
        case HKWorkoutActivityType.handCycling.rawValue:
            return "HandCycling"
        default:
            return "Other"
        }
    }
}
