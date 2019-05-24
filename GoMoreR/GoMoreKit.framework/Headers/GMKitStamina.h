//
//  GMKitStamina.h
//  GoMoreKit
//
//  Created by jake on 2018/10/2.
//  Copyright © 2018年 bOMDIC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMKitStamina : NSObject

- (NSString *)version;

/*!
 @brief Stands for SDK initialization. This method will check validation of the SDK.
 @param pKey Secret key given by GoMore system by calling API or provided by GoMore administrator.
 @param attribute Attribute given by GoMore system by calling API.
 @param deviceId Device ID registered in GoMore system.
 @param currentDateTime RTC time of the device.
 @return Status of initialized result.
 */
- (int)sdkInit:(NSString *)pKey
     attribute:(NSString *)attribute
      deviceId:(NSString *)deviceId
currentDateTime:(int)currentDateTime;

/*!
 @brief Sets user data into SDK before activity index calculation.
 @param age Age should be > 10 and < 100.
 @param gender 0: female; 1: male.
 @param heightCm In cm, value should be between 100 ~ 250 cm.
 @param weightKg In kg, value should be between 10 ~ 300 kg.
 @param hrMax Maximum heart rate of the user.
 @param hrRest Resting heart rate of the user.
 @param aerobicPtc Aerobic status of last workout, in percentage.
 @param anaerobicPtc Anaerobic status of last workout, in percentage.
 @param staminaLevel StaminaLevel from Server API.
 @param teAerobic Training effect of aerobic. If new workout should be 0. If a continued workout should be last value.
 @param teAnaerobic Training effect of anaerobic. If new workout should be 0. If a continued workout should be last value.
 @param teStamina Training effect of stamina. If new workout should be 0. If a continued workout should be last value.
 @param kcal Initial value of calorie. Sets to 0 for a new workout.
 @param distance Distance of workout. If new workout should be 0. If a continued workout should be last value.
 @param elapsedSecond Seconds elapsed since last workout end.
 @param checkSum Value got from API: init_workout.php. Takes this value to get current stamina level calibrated from server.
 @param sportType 31: indoor run, 32: run 21: indoor cycle, 22: cycle
 @return Status of initialized result.
 */
- (int)initUser:(int)age
         gender:(int)gender
       heightCm:(int)heightCm
       weightKg:(int)weightKg
          hrMax:(int)hrMax
         hrRest:(int)hrRest
     aerobicPtc:(float)aerobicPtc
   anaerobicPtc:(float)anaerobicPtc
   staminaLevel:(float)staminaLevel
      teAerobic:(float)teAerobic
    teAnaerobic:(float)teAnaerobic
      teStamina:(float)teStamina
           kcal:(float)kcal
       distance:(float)distance
  elapsedSecond:(int)elapsedSecond
       checkSum:(NSString *)checkSum
      sportType:(int)sportType;

/*!
 @brief Updates user heart rate of the workout to SDK. This is real time calculation, heart rate is needed every second.
 @param currentDateTime Current date time of the device.
 @param timerSec Second of the workout, starting from 0.
 @param hrRaw Heart rate from sensor.
 @param speed Speed of the workout. Unit is kph.
 @param cyclingCadence Cadence rate from sensor.
 @param cyclingPower Power rate from sensor.
 @return Status of calling result.
 */
- (int)updateHr:(int)currentDateTime
       timerSec:(int)timerSec
          hrRaw:(int)hrRaw
          speed:(float)speed
 cyclingCadence:(int)cyclingCadence
   cyclingPower:(int)cyclingPower;

/*!
 @brief Updates user heart rate of the workout to SDK. This is real time calculation, heart rate is needed every second.
 @param currentDateTime Current date time of the device.
 @param timerSec Second of the workout, starting from 0.
 @param hrRaw Heart rate from sensor.
 @param speed Speed. Unit is kph.
 @param longitude Longitude. Sets to -1 if no longitude.
 @param latitude Latitude. Sets to -1 if no latitude.
 @param altitude Altitude.
 @param cyclingCadence Cadence rate from sensor.
 @param cyclingPower Power rate from sensor.
 @return Calculated predict heart rate. If the value is < 0, it is error code.
 */
- (int)updateHrGpsPower:(int)currentDateTime
               timerSec:(int)timerSec
                  hrRaw:(int)hrRaw
                  speed:(float)speed
              longitude:(float)longitude
               latitude:(float)latitude
               altitude:(float)altitude
         cyclingCadence:(int)cyclingCadence
           cyclingPower:(int)cyclingPower;

/*!
 @brief Updates route information of the workout to SDK.
 @param currentDateTime Current date time of the device.
 @param timerSec Second of the workout, starting from 0.
 @param longitude Longitude. Sets to -1 if no longitude.
 @param latitude Latitude. Sets to -1 if no latitude.
 @param altitude Altitude.
 @return Current distance.
 */
- (float)updateRoute:(int)currentDateTime
            timerSec:(int)timerSec
           longitude:(double)longitude
            latitude:(double)latitude
            altitude:(float)altitude;

- (NSArray *)updateRouteFusion:(float)longitude
                      latitude:(float)latitude
                      altitude:(float)altitude
               accuracyHorizon:(float)accuracyHorizon
              accuracyVertical:(float)accuracyVertical
                          accX:(float)accX
                          accY:(float)accY
                          accZ:(float)accZ;

/*!
 @brief Gets distance from acc instead of gps data. This feature is an option, if GPS is available, may use GoMoreKit.SDK.updateRoute only. Acc frequency supported in GoMore SDK are: 50 Hz or 40 Hz. Should provide supported frequency before using this method.
 @param accX X of acc data.
 @param accY Y of acc data.
 @param accZ Z of acc data.
 @param longitude Longitude. Sets to -1 if no longitude.
 @param latitude Latitude. Sets to -1 if no latitude.
 @param hr Heart rate from sensor.
 @param sportType 31: indoor run, 32: run 21: indoor cycle, 22: cycle
 @param dt Date time difference of each acc value.
 @return Calculated value array. [1] is distance. [2] is step. [3] is speed(kph). If the value is < 0, it is error code. If the value is = -1, it means SDK still waiting calculated result.
 */
- (NSArray *)updateDistanceKm:(double)accX
                         accY:(double)accY
                         accZ:(double)accZ
                    longitude:(double)longitude
                     latitude:(double)latitude
                           hr:(int)hr
                    sportType:(int)sportType
                           dt:(int)dt;

/*!
 @brief Inputs distance to SDK instead of getting distance acc or gps from SDK.
 @param distanceKm Distance of the current time, in Km. Total distance of the workout.
 @param accX X of acc data.
 @param accY Y of acc data.
 @param accZ Z of acc data.
 @param speed Speed.
 @param currentDateTime Current date time of the device.
 @return Current distance.
 */
- (float)inputDistanceKm:(float)distanceKm
                    accX:(double)accX
                    accY:(double)accY
                    accZ:(double)accZ
                   speed:(float)speed
         currentDateTime:(int)currentDateTime;

/*!
 @brief Gets maximum distance of the workout expected when running out of stamina.
 @param sportType 31: indoor run, 32: run, 21: indoor cycle, 22: cycle
 @return Calculated maximum distance. If the value is < 0, it is error code.
 */
- (float)predictMaxDistance:(int)sportType;

/*!
 @brief Gets heartrate zone of the workout currently.
 @param hrRaw Heart rate from sensor.
 @return Calculated heart rate zone. If the value is < 0, it is error code.
 */
- (int)hrZone:(int)hrRaw;

/*!
 @brief Gets heart rate value after SDK filter.
 @return Calculated heart rate. If the value is < 0, it is error code.
 */
- (int)getHrRate;

/*!
 @brief Gets current aerobic state in a workout, in percentage.
 @return Calculated aerobic state. If the value is < 0, it is error code.
 */
- (float)aerobic;

/*!
 @brief Gets current anaerobic state in a workout, in percentage.
 @return Calculated anaerobic state. If the value is < 0, it is error code.
 */
- (float)anaerobic;

/*!
 @brief Gets current stamina state of a workout, in percentage.
 @return Calculated stamina state. If the value is < 0, it is error code.
 */
- (float)stamina;

/*!
 @brief Gets the zone for aerobic.
 @return Calculated zone for zone of aerobic. From zone 1 to 5. If the value is < 0, it is error code.
 */
- (int)aerobicZone;

/*!
 @brief Gets the zone for anaerobic.
 @return Calculated zone for zone of anaerobic. From zone 1 to 5. If the value is < 0, it is error code.
 */
- (int)anaerobicZone;

/*!
 @brief Gets the zone for stamina.
 @return Calculated zone for zone of stamina. From zone 1 to 5. If the value is < 0, it is error code.
 */
- (int)staminaZone;

/*!
 @brief Gets current calories consumed in the workout.
 @return Calculated calories. If the value is < 0, it is error code.
 */
- (float)kcal;

/*!
 @brief Gets training effect of stamina.
 @return Calculated training effect of stamina. If the value is < 0, it is error code.
 */
- (float)teStamina;

/*!
 @brief Gets training effect of aerobic.
 @return Calculated training effect of aerobic. If the value is < 0, it is error code.
 */
- (float)teAerobic;

/*!
 @brief Gets training effect of anaerobic.
 @return Calculated training effect of anaerobic. If the value is < 0, it is error code.
 */
- (float)teAnaerobic;

/*!
 @brief Gets the zone for training effect of stamina.
 @return Calculated zone for training effect of stamina. If the value is < 0, it is error code.
 */
- (int)teStaminaZone;

/*!
 @brief Gets the zone for training effect of aerobic.
 @return Calculated zone for training effect of aerobic. If the value is < 0, it is error code.
 */
- (int)teAerobicZone;

/*!
 @brief Gets the zone for training effect of anaerobic.
 @return Calculated zone for training effect of anaerobic. If the value is < 0, it is error code.
 */
- (int)teAnaerobicZone;

/*!
 @brief Time needed to achieve the training effect of stamina of selected target.
 @param targetTrainingEffect Training effect user expected.
 @return Calculated time needed to achieve the training effect of stamina. If the value is < 0, it is error code.
 */
- (int)teStaminaSecond:(float)targetTrainingEffect;

/*!
 @brief Time needed to achieve the training effect of aerobic of selected target.
 @param targetTrainingEffect Training effect user expected.
 @return Calculated time needed to achieve the training effect of aerobic. If the value is < 0, it is error code.
 */
- (int)teAerobicSecond:(float)targetTrainingEffect;

/*!
 @brief Time needed to achieve the training effect of anaerobic of selected target.
 @param targetTrainingEffect Training effect user expected.
 @return Calculated time needed to achieve the training effect of anaerobic. If the value is < 0, it is error code.
 */
- (int)teAnaerobicSecond:(float)targetTrainingEffect;

/*!
 @brief Speed needed to achieve the training effect of stamina of selected target.
 @param targetTrainingEffect Training effect user expected.
 @return Calculated speed status. If the value is = 1, it is needed speed up. If the value is = 0, it is keeping. If the value is = -1, it is needed slow down. If the value is < 0, it is error code.
 */
- (int)teStaminaSpeed:(float)targetTrainingEffect;

/*!
 @brief Speed needed to achieve the training effect of aerobic of selected target.
 @param targetTrainingEffect Training effect user expected.
 @return Calculated speed status. If the value is = 1, it is needed speed up. If the value is = 0, it is keeping. If the value is = -1, it is needed slow down. If the value is < 0, it is error code.
 */
- (int)teAerobicSpeed:(float)targetTrainingEffect;

/*!
 @brief Speed needed to achieve the training effect of anaerobic of selected target.
 @param targetTrainingEffect Training effect user expected.
 @return Calculated speed status. If the value is = 1, it is needed speed up. If the value is = 0, it is keeping. If the value is = -1, it is needed slow down. If the value is < 0, it is error code.
 */
- (int)teAnaerobicSpeed:(float)targetTrainingEffect;

/*!
 @brief Gets recovery time needed to have stamina back to 100%.
 @param elapsedSecond Time since last workout end, in second.
 @return Calculated seconds. If the value is < 0, it is error code.
 */
- (int)secondsRecovery:(int)elapsedSecond;

/*!
 @brief Get Recovery time by hour.
 @param elapsedSecond Time since last workout end, in second.
 @return Calculated hours. If the value is < 0, it is error code.
 */
- (int)hrsRecovery:(int)elapsedSecond;

/*!
 @brief Gets recovery time needed to have stamina back to 100%.
 @param aerobicPtc Aerobic status of last workout, in percentage.
 @param anaerobicPtc Anaerobic status of last workout, in percentage.
 @param elapsedSecond Time since last workout end, in second.
 @return Calculated seconds. If the value is < 0, it is error code.
 */
- (int)getSecondsRecovery:(float)aerobicPtc
             anaerobicPtc:(float)anaerobicPtc
            elapsedSecond:(int)elapsedSecond;

/*!
 @brief Get Recovery time by hour.
 @param aerobicPtc Aerobic status of last workout, in percentage.
 @param anaerobicPtc Anaerobic status of last workout, in percentage.
 @param elapsedSecond Time since last workout end, in second.
 @return Calculated hours. If the value is < 0, it is error code.
 */
- (int)getHrsRecovery:(float)aerobicPtc
         anaerobicPtc:(float)anaerobicPtc
        elapsedSecond:(int)elapsedSecond;

/*!
 @brief Gets stamina, aerobic and anaerobic status in percentage (%) after some time of a workout.
 @param aerobicPtc Aerobic status of last workout, in percentage.
 @param anaerobicPtc Anaerobic status of last workout, in percentage.
 @param elapsedSecond Time since last workout end, in second.
 @return Calculated values array. 0 is stamina%, 1 is aerobic%, 2 is anaerobic%. If array contains < 0 value, it is error code.
 */
- (NSArray *)getPercentageAfterRecovery:(float)aerobicPtc
                           anaerobicPtc:(float)anaerobicPtc
                          elapsedSecond:(int)elapsedSecond;

/*!
 @brief To stop this SDK session.
 */
- (void)stopSession;

@end

NS_ASSUME_NONNULL_END
