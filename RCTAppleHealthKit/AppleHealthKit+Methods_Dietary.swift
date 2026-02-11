//
//  AppleHealthKit+Methods_Dietary.swift
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit

extension AppleHealthKit {

    // MARK: - Energy Consumed

    func dietary_getEnergyConsumedSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let energyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.kilocalorie())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(energyConsumedType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the energy consumed sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the energy consumed sample", error, nil)])
                return
            }
        }
    }

    // MARK: - Total Fat

    func dietary_getTotalFatSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let fatTotalType = HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.gram())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(fatTotalType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the total fat sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the total fat sample", error, nil)])
                return
            }
        }
    }

    // MARK: - Protein

    func dietary_getProteinSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let proteinType = HKQuantityType.quantityType(forIdentifier: .dietaryProtein)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.gram())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(proteinType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the protein sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the protein sample", error, nil)])
                return
            }
        }
    }

    // MARK: - Fiber

    func dietary_getFiberSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let fiberType = HKQuantityType.quantityType(forIdentifier: .dietaryFiber)!
        let unit = AppleHealthKit.hkUnitFromOptions(input, key: "unit", withDefault: HKUnit.gram())
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(fiberType, unit: unit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the fiber sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the fiber sample", error, nil)])
                return
            }
        }
    }

    // MARK: - Save Food

    func dietary_saveFood(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let foodNameValue = AppleHealthKit.stringFromOptions(input, key: "foodName", withDefault: nil)
        let mealNameValue = AppleHealthKit.stringFromOptions(input, key: "mealType", withDefault: nil)
        let timeFoodWasConsumed = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())!
        let biotinValue = AppleHealthKit.doubleFromOptions(input, key: "biotin", withDefault: 0)
        let caffeineValue = AppleHealthKit.doubleFromOptions(input, key: "caffeine", withDefault: 0)
        let calciumValue = AppleHealthKit.doubleFromOptions(input, key: "calcium", withDefault: 0)
        let carbohydratesValue = AppleHealthKit.doubleFromOptions(input, key: "carbohydrates", withDefault: 0)
        let chlorideValue = AppleHealthKit.doubleFromOptions(input, key: "chloride", withDefault: 0)
        let cholesterolValue = AppleHealthKit.doubleFromOptions(input, key: "cholesterol", withDefault: 0)
        let copperValue = AppleHealthKit.doubleFromOptions(input, key: "copper", withDefault: 0)
        let energyConsumedValue = AppleHealthKit.doubleFromOptions(input, key: "energy", withDefault: 0)
        let fatMonounsaturatedValue = AppleHealthKit.doubleFromOptions(input, key: "fatMonounsaturated", withDefault: 0)
        let fatPolyunsaturatedValue = AppleHealthKit.doubleFromOptions(input, key: "fatPolyunsaturated", withDefault: 0)
        let fatSaturatedValue = AppleHealthKit.doubleFromOptions(input, key: "fatSaturated", withDefault: 0)
        let fatTotalValue = AppleHealthKit.doubleFromOptions(input, key: "fatTotal", withDefault: 0)
        let fiberValue = AppleHealthKit.doubleFromOptions(input, key: "fiber", withDefault: 0)
        let folateValue = AppleHealthKit.doubleFromOptions(input, key: "folate", withDefault: 0)
        let iodineValue = AppleHealthKit.doubleFromOptions(input, key: "iodine", withDefault: 0)
        let ironValue = AppleHealthKit.doubleFromOptions(input, key: "iron", withDefault: 0)
        let magnesiumValue = AppleHealthKit.doubleFromOptions(input, key: "magnesium", withDefault: 0)
        let manganeseValue = AppleHealthKit.doubleFromOptions(input, key: "manganese", withDefault: 0)
        let molybdenumValue = AppleHealthKit.doubleFromOptions(input, key: "molybdenum", withDefault: 0)
        let niacinValue = AppleHealthKit.doubleFromOptions(input, key: "niacin", withDefault: 0)
        let pantothenicAcidValue = AppleHealthKit.doubleFromOptions(input, key: "pantothenicAcid", withDefault: 0)
        let phosphorusValue = AppleHealthKit.doubleFromOptions(input, key: "phosphorus", withDefault: 0)
        let potassiumValue = AppleHealthKit.doubleFromOptions(input, key: "potassium", withDefault: 0)
        let proteinValue = AppleHealthKit.doubleFromOptions(input, key: "protein", withDefault: 0)
        let riboflavinValue = AppleHealthKit.doubleFromOptions(input, key: "riboflavin", withDefault: 0)
        let seleniumValue = AppleHealthKit.doubleFromOptions(input, key: "selenium", withDefault: 0)
        let sodiumValue = AppleHealthKit.doubleFromOptions(input, key: "sodium", withDefault: 0)
        let sugarValue = AppleHealthKit.doubleFromOptions(input, key: "sugar", withDefault: 0)
        let thiaminValue = AppleHealthKit.doubleFromOptions(input, key: "thiamin", withDefault: 0)
        let vitaminAValue = AppleHealthKit.doubleFromOptions(input, key: "vitaminA", withDefault: 0)
        let vitaminB12Value = AppleHealthKit.doubleFromOptions(input, key: "vitaminB12", withDefault: 0)
        let vitaminB6Value = AppleHealthKit.doubleFromOptions(input, key: "vitaminB6", withDefault: 0)
        let vitaminCValue = AppleHealthKit.doubleFromOptions(input, key: "vitaminC", withDefault: 0)
        let vitaminDValue = AppleHealthKit.doubleFromOptions(input, key: "vitaminD", withDefault: 0)
        let vitaminEValue = AppleHealthKit.doubleFromOptions(input, key: "vitaminE", withDefault: 0)
        let vitaminKValue = AppleHealthKit.doubleFromOptions(input, key: "vitaminK", withDefault: 0)
        let zincValue = AppleHealthKit.doubleFromOptions(input, key: "zinc", withDefault: 0)

        // Metadata including some new food-related keys
        let metadata: [String: Any] = [
            HKMetadataKeyFoodType: foodNameValue as Any,
            "HKFoodMeal": mealNameValue as Any,
        ]

        // Create nutritional data for food
        var mySet = Set<HKSample>()

        if biotinValue > 0 {
            let biotin = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryBiotin)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: biotinValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(biotin)
        }
        if caffeineValue > 0 {
            let caffeine = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: caffeineValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(caffeine)
        }
        if calciumValue > 0 {
            let calcium = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryCalcium)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: calciumValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(calcium)
        }
        if carbohydratesValue > 0 {
            let carbohydrates = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: carbohydratesValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(carbohydrates)
        }
        if chlorideValue > 0 {
            let chloride = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryChloride)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: chlorideValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(chloride)
        }
        if cholesterolValue > 0 {
            let cholesterol = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryCholesterol)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: cholesterolValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(cholesterol)
        }
        if copperValue > 0 {
            let copper = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryCopper)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: copperValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(copper)
        }
        if energyConsumedValue > 0 {
            let energyConsumed = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
                quantity: HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: energyConsumedValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(energyConsumed)
        }
        if fatMonounsaturatedValue > 0 {
            let fatMonounsaturated = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: fatMonounsaturatedValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(fatMonounsaturated)
        }
        if fatPolyunsaturatedValue > 0 {
            let fatPolyunsaturated = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: fatPolyunsaturatedValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(fatPolyunsaturated)
        }
        if fatSaturatedValue > 0 {
            let fatSaturated = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryFatSaturated)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: fatSaturatedValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(fatSaturated)
        }
        if fatTotalValue > 0 {
            let fatTotal = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: fatTotalValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(fatTotal)
        }
        if fiberValue > 0 {
            let fiber = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryFiber)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: fiberValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(fiber)
        }
        if folateValue > 0 {
            let folate = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryFolate)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: folateValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(folate)
        }
        if iodineValue > 0 {
            let iodine = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryIodine)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: iodineValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(iodine)
        }
        if ironValue > 0 {
            let iron = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryIron)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: ironValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(iron)
        }
        if magnesiumValue > 0 {
            let magnesium = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryMagnesium)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: magnesiumValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(magnesium)
        }
        if manganeseValue > 0 {
            let manganese = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryManganese)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: manganeseValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(manganese)
        }
        if molybdenumValue > 0 {
            let molybdenum = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryMolybdenum)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: molybdenumValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(molybdenum)
        }
        if niacinValue > 0 {
            let niacin = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryNiacin)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: niacinValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(niacin)
        }
        if pantothenicAcidValue > 0 {
            let pantothenicAcid = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryPantothenicAcid)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: pantothenicAcidValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(pantothenicAcid)
        }
        if phosphorusValue > 0 {
            let phosphorus = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryPhosphorus)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: phosphorusValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(phosphorus)
        }
        if potassiumValue > 0 {
            let potassium = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryPotassium)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: potassiumValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(potassium)
        }
        if proteinValue > 0 {
            let protein = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryProtein)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: proteinValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(protein)
        }
        if riboflavinValue > 0 {
            let riboflavin = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryRiboflavin)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: riboflavinValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(riboflavin)
        }
        if seleniumValue > 0 {
            let selenium = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietarySelenium)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: seleniumValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(selenium)
        }
        if sodiumValue > 0 {
            let sodium = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietarySodium)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: sodiumValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(sodium)
        }
        if sugarValue > 0 {
            let sugar = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietarySugar)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: sugarValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(sugar)
        }
        if thiaminValue > 0 {
            let thiamin = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryThiamin)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: thiaminValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(thiamin)
        }
        if vitaminAValue > 0 {
            let vitaminA = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminA)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminAValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminA)
        }
        if vitaminB12Value > 0 {
            let vitaminB12 = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB12)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminB12Value),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminB12)
        }
        if vitaminB6Value > 0 {
            let vitaminB6 = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB6)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminB6Value),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminB6)
        }
        if vitaminCValue > 0 {
            let vitaminC = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminC)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminCValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminC)
        }
        if vitaminDValue > 0 {
            let vitaminD = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminD)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminDValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminD)
        }
        if vitaminEValue > 0 {
            let vitaminE = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminE)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminEValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminE)
        }
        if vitaminKValue > 0 {
            let vitaminK = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryVitaminK)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: vitaminKValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(vitaminK)
        }
        if zincValue > 0 {
            let zinc = HKQuantitySample(
                type: HKQuantityType.quantityType(forIdentifier: .dietaryZinc)!,
                quantity: HKQuantity(unit: HKUnit.gram(), doubleValue: zincValue),
                start: timeFoodWasConsumed,
                end: timeFoodWasConsumed,
                metadata: metadata
            )
            mySet.insert(zinc)
        }

        // Combine nutritional data into a food correlation
        let food = HKCorrelation(
            type: HKCorrelationType.correlationType(forIdentifier: .food)!,
            start: timeFoodWasConsumed,
            end: timeFoodWasConsumed,
            objects: mySet,
            metadata: metadata
        )

        // Save the food correlation to HealthKit
        self.healthStore?.save(food) { success, error in
            if !success {
                NSLog("An error occured saving the food sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured saving the food sample", error, nil)])
                return
            }
            callback([NSNull(), true])
        }
    }

    // MARK: - Water

    func dietary_saveWater(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let timeWaterWasConsumed = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())!
        let waterValue = AppleHealthKit.doubleFromOptions(input, key: "value", withDefault: 0)

        let water = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .dietaryWater)!,
            quantity: HKQuantity(unit: HKUnit.liter(), doubleValue: waterValue),
            start: timeWaterWasConsumed,
            end: timeWaterWasConsumed,
            metadata: nil
        )

        // Save the water sample to HealthKit
        self.healthStore?.save(water) { success, error in
            if !success {
                NSLog("An error occured saving the water sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured saving the water sample", error, nil)])
                return
            }
            callback([NSNull(), true])
        }
    }

    func dietary_getWater(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let date = AppleHealthKit.dateFromOptions(input, key: "date", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if date == nil {
            callback([RCTMakeError("could not parse date from options.date", nil, nil)])
            return
        }

        let dietaryWaterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let literUnit = HKUnit.liter()

        self.fetchSumOfSamplesOnDayForType(dietaryWaterType, unit: literUnit, includeManuallyAdded: includeManuallyAdded, day: date!) { value, startDate, endDate, error in
            if !value.isNaN && !value.isInfinite || value == 0 {
                // value is valid
            } else {
                callback([RCTJSErrorFromNSError(error)])
                return
            }

            let response: [String: Any] = [
                "value": value,
                "startDate": AppleHealthKit.buildISO8601StringFromDate(startDate),
                "endDate": AppleHealthKit.buildISO8601StringFromDate(endDate),
            ]

            callback([NSNull(), response])
        }
    }

    func dietary_getWaterSamples(_ input: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
        let dietaryWaterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let literUnit = HKUnit.liter()
        let limit = AppleHealthKit.uintFromOptions(input, key: "limit", withDefault: HKObjectQueryNoLimit)
        let ascending = AppleHealthKit.boolFromOptions(input, key: "ascending", withDefault: false)
        let startDate = AppleHealthKit.dateFromOptions(input, key: "startDate", withDefault: nil)
        let endDate = AppleHealthKit.dateFromOptions(input, key: "endDate", withDefault: Date())
        let includeManuallyAdded = AppleHealthKit.boolFromOptions(input, key: "includeManuallyAdded", withDefault: true)

        if startDate == nil {
            callback([RCTMakeError("startDate is required in options", nil, nil)])
            return
        }

        let predicate = AppleHealthKit.predicateForSamplesBetweenDates(startDate, endDate: endDate)

        self.fetchQuantitySamplesOfType(dietaryWaterType, unit: literUnit, predicate: predicate, ascending: ascending, limit: limit) { results, error in
            if let results = results {
                callback([NSNull(), results])
                return
            } else {
                NSLog("An error occured while retrieving the water sample %@. The error was: ", error?.localizedDescription ?? "")
                callback([RCTMakeError("An error occured while retrieving the water sample", error, nil)])
                return
            }
        }
    }
}
