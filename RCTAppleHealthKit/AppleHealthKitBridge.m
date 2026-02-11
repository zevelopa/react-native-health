//
//  AppleHealthKitBridge.m
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(AppleHealthKit, RCTEventEmitter)

RCT_EXTERN_METHOD(isAvailable:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(initHealthKit:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(initStepCountObserver:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBiologicalSex:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBloodType:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDateOfBirth:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestWeight:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getWeightSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveWeight:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestHeight:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getHeightSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveHeight:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestWaistCircumference:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getWaistCircumferenceSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveWaistCircumference:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestPeakFlow:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getPeakFlowSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(savePeakFlow:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestBmi:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBmiSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveBmi:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestBodyFatPercentage:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBodyFatPercentageSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveBodyFatPercentage:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveBodyTemperature:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestLeanBodyMass:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLeanBodyMassSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveLeanBodyMass:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getStepCount:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getAnchoredWorkouts:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getWorkoutRouteSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(setObserver:(NSDictionary *)input)

RCT_EXTERN_METHOD(getDailyStepCountSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveSteps:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveWalkingRunningDistance:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDistanceWalkingRunning:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDailyDistanceWalkingRunningSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDistanceCycling:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDailyDistanceCyclingSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDistanceSwimming:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDailyDistanceSwimmingSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getFlightsClimbed:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getDailyFlightsClimbedSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getEnergyConsumedSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getProteinSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getFiberSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getTotalFatSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveFood:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveWater:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getWater:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveHeartRateSample:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getWaterSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getHeartRateSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getRestingHeartRate:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getWalkingHeartRateAverage:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getActiveEnergyBurned:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBasalEnergyBurned:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getAppleExerciseTime:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getAppleStandTime:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getVo2MaxSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBodyTemperatureSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBloodPressureSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getRespiratoryRateSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getHeartRateVariabilitySamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getHeartbeatSeriesSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getRestingHeartRateSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getOxygenSaturationSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getElectrocardiogramSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBloodGlucoseSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getCarbohydratesSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getInsulinDeliverySamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveInsulinDeliverySample:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(deleteInsulinDeliverySample:(NSString *)oid
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveCarbohydratesSample:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(deleteCarbohydratesSample:(NSString *)oid
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveBloodGlucoseSample:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(deleteBloodGlucoseSample:(NSString *)oid
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getSleepSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getInfo:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getMindfulSession:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveMindfulSession:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveWorkout:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getAuthStatus:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getLatestBloodAlcoholContent:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getBloodAlcoholContentSamples:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(saveBloodAlcoholContent:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getEnvironmentalAudioExposure:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getHeadphoneAudioExposure:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getActivitySummary:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(getClinicalRecords:(NSDictionary *)input
                  callback:(RCTResponseSenderBlock)callback)

@end
