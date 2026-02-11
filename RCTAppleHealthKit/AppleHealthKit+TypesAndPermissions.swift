//
//  AppleHealthKit+TypesAndPermissions.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - HealthKit Permissions

    func getReadPermFromText(_ key: String) -> HKObjectType? {
        let deviceInfo = UIDevice.current
        let systemVersion = (deviceInfo.systemVersion as NSString).floatValue

        // Characteristic Identifiers
        if key == "Height" {
            return HKObjectType.quantityType(forIdentifier: .height)
        } else if key == "Weight" {
            return HKObjectType.quantityType(forIdentifier: .bodyMass)
        } else if key == "DateOfBirth" {
            return HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
        } else if key == "BiologicalSex" {
            return HKObjectType.characteristicType(forIdentifier: .biologicalSex)
        } else if key == "BloodType" {
            return HKObjectType.characteristicType(forIdentifier: .bloodType)
        } else if key == "PeakFlow" {
            return HKObjectType.quantityType(forIdentifier: .peakExpiratoryFlowRate)
        } else if key == "WaistCircumference" {
            if #available(iOS 11.0, *) {
                return HKObjectType.quantityType(forIdentifier: .waistCircumference)
            } else {
                return nil
            }
        }

        // Body Measurements
        if key == "BodyMass" {
            return HKObjectType.quantityType(forIdentifier: .bodyMass)
        } else if key == "BodyFatPercentage" {
            return HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)
        } else if key == "BodyMassIndex" {
            return HKObjectType.quantityType(forIdentifier: .bodyMassIndex)
        } else if key == "LeanBodyMass" {
            return HKObjectType.quantityType(forIdentifier: .leanBodyMass)
        }

        // Hearing Identifiers
        if #available(iOS 13.0, *) {
            if key == "EnvironmentalAudioExposure" {
                return HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)
            } else if key == "HeadphoneAudioExposure" {
                return HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)
            }
        }

        // Fitness Identifiers
        if key == "Steps" {
            return HKObjectType.quantityType(forIdentifier: .stepCount)
        } else if key == "StepCount" {
            return HKObjectType.quantityType(forIdentifier: .stepCount)
        } else if key == "DistanceWalkingRunning" {
            return HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        } else if key == "RunningSpeed" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningSpeed)
            } else {
                return nil
            }
        } else if key == "DistanceCycling" {
            return HKObjectType.quantityType(forIdentifier: .distanceCycling)
        } else if key == "DistanceSwimming" {
            return HKObjectType.quantityType(forIdentifier: .distanceSwimming)
        } else if key == "BasalEnergyBurned" {
            return HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)
        } else if key == "ActiveEnergyBurned" {
            return HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        } else if key == "FlightsClimbed" {
            return HKObjectType.quantityType(forIdentifier: .flightsClimbed)
        } else if key == "NikeFuel" {
            return HKObjectType.quantityType(forIdentifier: .nikeFuel)
        } else if key == "AppleStandTime" {
            return HKObjectType.quantityType(forIdentifier: .appleStandTime)
        } else if key == "AppleExerciseTime" && systemVersion >= 9.3 {
            return HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        } else if key == "RunningPower" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningPower)
            } else {
                return nil
            }
        } else if key == "RunningStrideLength" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningStrideLength)
            } else {
                return nil
            }
        } else if key == "RunningVerticalOscillation" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningVerticalOscillation)
            } else {
                return nil
            }
        } else if key == "RunningGroundContactTime" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningGroundContactTime)
            } else {
                return nil
            }
        }

        // Nutrition Identifiers
        if key == "Biotin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryBiotin)
        } else if key == "Caffeine" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)
        } else if key == "Calcium" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCalcium)
        } else if key == "Carbohydrates" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)
        } else if key == "Chloride" {
            return HKObjectType.quantityType(forIdentifier: .dietaryChloride)
        } else if key == "Cholesterol" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCholesterol)
        } else if key == "Copper" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCopper)
        } else if key == "EnergyConsumed" {
            return HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        } else if key == "FatMonounsaturated" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated)
        } else if key == "FatPolyunsaturated" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)
        } else if key == "FatSaturated" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)
        } else if key == "FatTotal" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)
        } else if key == "Fiber" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFiber)
        } else if key == "Folate" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFolate)
        } else if key == "Iodine" {
            return HKObjectType.quantityType(forIdentifier: .dietaryIodine)
        } else if key == "Iron" {
            return HKObjectType.quantityType(forIdentifier: .dietaryIron)
        } else if key == "Magnesium" {
            return HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)
        } else if key == "Manganese" {
            return HKObjectType.quantityType(forIdentifier: .dietaryManganese)
        } else if key == "Molybdenum" {
            return HKObjectType.quantityType(forIdentifier: .dietaryMolybdenum)
        } else if key == "Niacin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryNiacin)
        } else if key == "PantothenicAcid" {
            return HKObjectType.quantityType(forIdentifier: .dietaryPantothenicAcid)
        } else if key == "Phosphorus" {
            return HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus)
        } else if key == "Potassium" {
            return HKObjectType.quantityType(forIdentifier: .dietaryPotassium)
        } else if key == "Protein" {
            return HKObjectType.quantityType(forIdentifier: .dietaryProtein)
        } else if key == "Riboflavin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryRiboflavin)
        } else if key == "Selenium" {
            return HKObjectType.quantityType(forIdentifier: .dietarySelenium)
        } else if key == "Sodium" {
            return HKObjectType.quantityType(forIdentifier: .dietarySodium)
        } else if key == "Sugar" {
            return HKObjectType.quantityType(forIdentifier: .dietarySugar)
        } else if key == "Thiamin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryThiamin)
        } else if key == "VitaminA" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)
        } else if key == "VitaminB12" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)
        } else if key == "VitaminB6" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)
        } else if key == "VitaminC" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)
        } else if key == "VitaminD" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)
        } else if key == "VitaminE" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)
        } else if key == "VitaminK" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)
        } else if key == "Zinc" {
            return HKObjectType.quantityType(forIdentifier: .dietaryZinc)
        } else if key == "Water" {
            return HKObjectType.quantityType(forIdentifier: .dietaryWater)
        } else if key == "BloodGlucose" {
            return HKObjectType.quantityType(forIdentifier: .bloodGlucose)
        } else if key == "InsulinDelivery" {
            return HKObjectType.quantityType(forIdentifier: .insulinDelivery)
        }

        // Vital Signs Identifiers
        if key == "HeartRate" {
            return HKObjectType.quantityType(forIdentifier: .heartRate)
        } else if key == "WalkingHeartRateAverage" {
            return HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)
        } else if key == "RestingHeartRate" {
            return HKObjectType.quantityType(forIdentifier: .restingHeartRate)
        } else if key == "HeartRateVariability" {
            return HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        } else if key == "HeartbeatSeries" && systemVersion >= 13.0 {
            return HKSeriesType.heartbeat()
        } else if key == "Vo2Max" && systemVersion >= 11.0 {
            return HKObjectType.quantityType(forIdentifier: .vo2Max)
        } else if key == "BodyTemperature" {
            return HKObjectType.quantityType(forIdentifier: .bodyTemperature)
        } else if key == "BloodPressureSystolic" {
            return HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)
        } else if key == "BloodPressureDiastolic" {
            return HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)
        } else if key == "RespiratoryRate" {
            return HKObjectType.quantityType(forIdentifier: .respiratoryRate)
        } else if key == "OxygenSaturation" {
            return HKObjectType.quantityType(forIdentifier: .oxygenSaturation)
        } else if key == "Electrocardiogram" && systemVersion >= 14.0 {
            return HKObjectType.electrocardiogramType()
        }

        // Sleep
        if key == "SleepAnalysis" {
            return HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        }

        // Workouts
        if key == "MindfulSession" && systemVersion >= 10.0 {
            return HKObjectType.categoryType(forIdentifier: .mindfulSession)
        } else if key == "MindfulSession" {
            return HKObjectType.workoutType()
        } else if key == "Workout" {
            return HKObjectType.workoutType()
        } else if key == "WorkoutRoute" {
            return HKSeriesType.workoutRoute()
        }

        // Lab and Tests
        if key == "BloodAlcoholContent" {
            return HKObjectType.quantityType(forIdentifier: .bloodAlcoholContent)
        }

        // Activity Summary
        if key == "ActivitySummary" {
            return HKObjectType.activitySummaryType()
        }

        // Clinical Records
        if key == "AllergyRecord" {
            return AppleHealthKit.clinicalTypeFromName("AllergyRecord")
        } else if key == "ConditionRecord" {
            return AppleHealthKit.clinicalTypeFromName("ConditionRecord")
        } else if key == "CoverageRecord" {
            return AppleHealthKit.clinicalTypeFromName("CoverageRecord")
        } else if key == "ImmunizationRecord" {
            return AppleHealthKit.clinicalTypeFromName("ImmunizationRecord")
        } else if key == "LabResultRecord" {
            return AppleHealthKit.clinicalTypeFromName("LabResultRecord")
        } else if key == "MedicationRecord" {
            return AppleHealthKit.clinicalTypeFromName("MedicationRecord")
        } else if key == "ProcedureRecord" {
            return AppleHealthKit.clinicalTypeFromName("ProcedureRecord")
        } else if key == "VitalSignRecord" {
            return AppleHealthKit.clinicalTypeFromName("VitalSignRecord")
        }

        // New iOS 16 Types
        if #available(iOS 16.0, *) {
            if key == "UnderwaterDepth" {
                return HKObjectType.quantityType(forIdentifier: .underwaterDepth)
            } else if key == "WaterTemperature" {
                return HKObjectType.quantityType(forIdentifier: .waterTemperature)
            }
        }

        // New iOS 17 Types
        if #available(iOS 17.0, *) {
            if key == "CyclingSpeed" {
                return HKObjectType.quantityType(forIdentifier: .cyclingSpeed)
            } else if key == "CyclingPower" {
                return HKObjectType.quantityType(forIdentifier: .cyclingPower)
            } else if key == "CyclingCadence" {
                return HKObjectType.quantityType(forIdentifier: .cyclingCadence)
            } else if key == "CyclingFunctionalThresholdPower" {
                return HKObjectType.quantityType(forIdentifier: .cyclingFunctionalThresholdPower)
            } else if key == "PhysicalEffort" {
                return HKObjectType.quantityType(forIdentifier: .physicalEffort)
            } else if key == "TimeInDaylight" {
                return HKObjectType.quantityType(forIdentifier: .timeInDaylight)
            }
        }

        // New iOS 18 Types
        if #available(iOS 18.0, *) {
            if key == "WorkoutEffortScore" {
                return HKObjectType.quantityType(forIdentifier: .workoutEffortScore)
            } else if key == "EstimatedWorkoutEffortScore" {
                return HKObjectType.quantityType(forIdentifier: .estimatedWorkoutEffortScore)
            } else if key == "AppleSleepingBreathingDisturbances" {
                return HKObjectType.quantityType(forIdentifier: .appleSleepingBreathingDisturbances)
            }
        }

        return nil
    }

    func getWritePermFromText(_ key: String) -> HKObjectType? {
        // Body Measurements
        if key == "Height" {
            return HKObjectType.quantityType(forIdentifier: .height)
        } else if key == "PeakFlow" {
            return HKObjectType.quantityType(forIdentifier: .peakExpiratoryFlowRate)
        } else if key == "WaistCircumference" {
            return HKObjectType.quantityType(forIdentifier: .waistCircumference)
        } else if key == "Weight" {
            return HKObjectType.quantityType(forIdentifier: .bodyMass)
        } else if key == "BodyMass" {
            return HKObjectType.quantityType(forIdentifier: .bodyMass)
        } else if key == "BodyFatPercentage" {
            return HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)
        } else if key == "BodyMassIndex" {
            return HKObjectType.quantityType(forIdentifier: .bodyMassIndex)
        } else if key == "LeanBodyMass" {
            return HKObjectType.quantityType(forIdentifier: .leanBodyMass)
        } else if key == "BodyTemperature" {
            return HKObjectType.quantityType(forIdentifier: .bodyTemperature)
        }

        // Fitness Identifiers
        if key == "Steps" {
            return HKObjectType.quantityType(forIdentifier: .stepCount)
        } else if key == "StepCount" {
            return HKObjectType.quantityType(forIdentifier: .stepCount)
        } else if key == "DistanceWalkingRunning" {
            return HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        } else if key == "RunningSpeed" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningSpeed)
            } else {
                return nil
            }
        } else if key == "DistanceCycling" {
            return HKObjectType.quantityType(forIdentifier: .distanceCycling)
        } else if key == "DistanceSwimming" {
            return HKObjectType.quantityType(forIdentifier: .distanceSwimming)
        } else if key == "BasalEnergyBurned" {
            return HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)
        } else if key == "ActiveEnergyBurned" {
            return HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        } else if key == "FlightsClimbed" {
            return HKObjectType.quantityType(forIdentifier: .flightsClimbed)
        } else if key == "RunningPower" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningPower)
            } else {
                return nil
            }
        } else if key == "RunningStrideLength" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningStrideLength)
            } else {
                return nil
            }
        } else if key == "RunningVerticalOscillation" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningVerticalOscillation)
            } else {
                return nil
            }
        } else if key == "RunningGroundContactTime" {
            if #available(iOS 16.0, *) {
                return HKObjectType.quantityType(forIdentifier: .runningGroundContactTime)
            } else {
                return nil
            }
        }

        // Nutrition Identifiers
        if key == "Biotin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryBiotin)
        } else if key == "Caffeine" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)
        } else if key == "Calcium" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCalcium)
        } else if key == "Carbohydrates" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)
        } else if key == "Chloride" {
            return HKObjectType.quantityType(forIdentifier: .dietaryChloride)
        } else if key == "Cholesterol" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCholesterol)
        } else if key == "Copper" {
            return HKObjectType.quantityType(forIdentifier: .dietaryCopper)
        } else if key == "EnergyConsumed" {
            return HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        } else if key == "FatMonounsaturated" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated)
        } else if key == "FatPolyunsaturated" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)
        } else if key == "FatSaturated" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)
        } else if key == "FatTotal" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)
        } else if key == "Fiber" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFiber)
        } else if key == "Folate" {
            return HKObjectType.quantityType(forIdentifier: .dietaryFolate)
        } else if key == "Iodine" {
            return HKObjectType.quantityType(forIdentifier: .dietaryIodine)
        } else if key == "Iron" {
            return HKObjectType.quantityType(forIdentifier: .dietaryIron)
        } else if key == "Magnesium" {
            return HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)
        } else if key == "Manganese" {
            return HKObjectType.quantityType(forIdentifier: .dietaryManganese)
        } else if key == "Molybdenum" {
            return HKObjectType.quantityType(forIdentifier: .dietaryMolybdenum)
        } else if key == "Niacin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryNiacin)
        } else if key == "PantothenicAcid" {
            return HKObjectType.quantityType(forIdentifier: .dietaryPantothenicAcid)
        } else if key == "Phosphorus" {
            return HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus)
        } else if key == "Potassium" {
            return HKObjectType.quantityType(forIdentifier: .dietaryPotassium)
        } else if key == "Protein" {
            return HKObjectType.quantityType(forIdentifier: .dietaryProtein)
        } else if key == "Riboflavin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryRiboflavin)
        } else if key == "Selenium" {
            return HKObjectType.quantityType(forIdentifier: .dietarySelenium)
        } else if key == "Sodium" {
            return HKObjectType.quantityType(forIdentifier: .dietarySodium)
        } else if key == "Sugar" {
            return HKObjectType.quantityType(forIdentifier: .dietarySugar)
        } else if key == "Thiamin" {
            return HKObjectType.quantityType(forIdentifier: .dietaryThiamin)
        } else if key == "VitaminA" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)
        } else if key == "VitaminB12" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)
        } else if key == "VitaminB6" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)
        } else if key == "VitaminC" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)
        } else if key == "VitaminD" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)
        } else if key == "VitaminE" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)
        } else if key == "VitaminK" {
            return HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)
        } else if key == "Zinc" {
            return HKObjectType.quantityType(forIdentifier: .dietaryZinc)
        } else if key == "Water" {
            return HKObjectType.quantityType(forIdentifier: .dietaryWater)
        } else if key == "BloodGlucose" {
            return HKObjectType.quantityType(forIdentifier: .bloodGlucose)
        } else if key == "InsulinDelivery" {
            return HKObjectType.quantityType(forIdentifier: .insulinDelivery)
        }

        // Sleep
        if key == "SleepAnalysis" {
            return HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        }

        // Mindfulness
        if key == "MindfulSession" {
            return HKObjectType.categoryType(forIdentifier: .mindfulSession)
        }

        // Workout
        if key == "Workout" {
            return HKObjectType.workoutType()
        }

        // Workout Route
        if key == "WorkoutRoute" {
            if #available(iOS 11.0, *) {
                return HKSeriesType.workoutRoute()
            } else {
                return nil
            }
        }

        // Lab and Tests
        if key == "BloodAlcoholContent" {
            return HKObjectType.quantityType(forIdentifier: .bloodAlcoholContent)
        }
        if key == "HeartRate" {
            return HKObjectType.quantityType(forIdentifier: .heartRate)
        }

        return nil
    }

    // Returns HealthKit read permissions from options array
    func getReadPermsFromOptions(_ options: [Any]) -> Set<HKObjectType> {
        var readPermSet = Set<HKObjectType>()

        for i in 0..<options.count {
            if let optionKey = options[i] as? String {
                if let val = getReadPermFromText(optionKey) {
                    readPermSet.insert(val)
                }
            }
        }
        return readPermSet
    }

    // Returns HealthKit write permissions from options array
    func getWritePermsFromOptions(_ options: [Any]) -> Set<HKObjectType> {
        var writePermSet = Set<HKObjectType>()

        for i in 0..<options.count {
            if let optionKey = options[i] as? String {
                if let val = getWritePermFromText(optionKey) {
                    writePermSet.insert(val)
                }
            }
        }
        return writePermSet
    }

    func getWritePermFromString(_ writePerm: String) -> HKObjectType? {
        return getWritePermFromText(writePerm)
    }

    func getAuthorizationStatusString(_ status: HKAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "NotDetermined"
        case .sharingDenied:
            return "SharingDenied"
        case .sharingAuthorized:
            return "SharingAuthorized"
        @unknown default:
            return "NotDetermined"
        }
    }

    static func getStringToWorkoutActivityTypeDictionary() -> [String: HKWorkoutActivityType] {
        let elem: [String: HKWorkoutActivityType] = [
            "AmericanFootball": .americanFootball,
            "Archery": .archery,
            "AustralianFootball": .australianFootball,
            "Badminton": .badminton,
            "Baseball": .baseball,
            "Basketball": .basketball,
            "Bowling": .bowling,
            "Boxing": .boxing,
            "Climbing": .climbing,
            "Cricket": .cricket,
            "CrossTraining": .crossTraining,
            "Curling": .curling,
            "Cycling": .cycling,
            "Dance": .dance,
            "DanceInspiredTraining": .danceInspiredTraining,
            "Elliptical": .elliptical,
            "EquestrianSports": .equestrianSports,
            "Fencing": .fencing,
            "Fishing": .fishing,
            "FunctionalStrengthTraining": .functionalStrengthTraining,
            "Golf": .golf,
            "Gymnastics": .gymnastics,
            "Handball": .handball,
            "Hiking": .hiking,
            "Hockey": .hockey,
            "Hunting": .hunting,
            "Lacrosse": .lacrosse,
            "MartialArts": .martialArts,
            "MindAndBody": .mindAndBody,
            "MixedMetabolicCardioTraining": .mixedMetabolicCardioTraining,
            "PaddleSports": .paddleSports,
            "Play": .play,
            "PreparationAndRecovery": .preparationAndRecovery,
            "Racquetball": .racquetball,
            "Rowing": .rowing,
            "Rugby": .rugby,
            "Running": .running,
            "Sailing": .sailing,
            "SkatingSports": .skatingSports,
            "SnowSports": .snowSports,
            "Soccer": .soccer,
            "Softball": .softball,
            "Squash": .squash,
            "StairClimbing": .stairClimbing,
            "SurfingSports": .surfingSports,
            "Swimming": .swimming,
            "TableTennis": .tableTennis,
            "Tennis": .tennis,
            "TrackAndField": .trackAndField,
            "TraditionalStrengthTraining": .traditionalStrengthTraining,
            "Volleyball": .volleyball,
            "Walking": .walking,
            "WaterFitness": .waterFitness,
            "WaterPolo": .waterPolo,
            "WaterSports": .waterSports,
            "Wrestling": .wrestling,
            "Yoga": .yoga,
            "Barre": .barre,
            "CoreTraining": .coreTraining,
            "CrossCountrySkiing": .crossCountrySkiing,
            "DownhillSkiing": .downhillSkiing,
            "Flexibility": .flexibility,
            "HighIntensityIntervalTraining": .highIntensityIntervalTraining,
            "JumpRope": .jumpRope,
            "Kickboxing": .kickboxing,
            "Pilates": .pilates,
            "Snowboarding": .snowboarding,
            "Stairs": .stairs,
            "StepTraining": .stepTraining,
            "WheelchairWalkPace": .wheelchairWalkPace,
            "WheelchairRunPace": .wheelchairRunPace,
            "TaiChi": .taiChi,
            "MixedCardio": .mixedCardio,
            "HandCycling": .handCycling,
            "DiscSports": .discSports,
            "FitnessGaming": .fitnessGaming,
            "CardioDance": .cardioDance,
            "SocialDance": .socialDance,
            "Pickleball": .pickleball,
            "Cooldown": .cooldown,
            "Other": .other,
        ]
        return elem
    }

    static func getNumberToWorkoutNameDictionary() -> NSDictionary {
        let stringToType = getStringToWorkoutActivityTypeDictionary()
        let result = NSMutableDictionary()
        for (name, activityType) in stringToType {
            let key = NSNumber(value: activityType.rawValue)
            result[key] = name
        }
        return result
    }
}
