//
//  HealthStore.swift
//  Infits
//
//  Created by Chitrala Dhruv on 24/01/23.
//

import Foundation
import HealthKit

extension Date {
    static func mondayAt12AM() -> Date {
        return (Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear], from: Date()))!)
    }
}

class HealthStore {
    var healthStore: HKHealthStore?
    var query: HKStatisticsQuery?
    var query1: HKStatisticsCollectionQuery?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorisation(completion: @escaping(Bool) -> Void) {

        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let avgSpeedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        let energyConsumed = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let distanceWalked = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!

        guard let healthStore = self.healthStore else { return completion(false) }
        healthStore.requestAuthorization(toShare: [], read: [stepType, avgSpeedType, energyConsumed, distanceWalked]) { (success, error) in
            completion(success)
        }
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )

        query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }

        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func getAvgSpeed(completion: @escaping(Double?) -> Void) {
        let avgSpeedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)

        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
        
        guard let st = calendar.date(byAdding: .day, value: -2, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }
         
        guard let endDate = calendar.date(byAdding: .day, value: -1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }

        let today = HKQuery.predicateForSamples(withStart: st, end: endDate, options: [])
        
        let query1 = HKStatisticsQuery(quantityType: avgSpeedType, quantitySamplePredicate: today, options: .discreteAverage) { (query, statisticsOrNil, errorOrNil) in
            
            guard let statistics = statisticsOrNil else {
                // Handle any errors here.
                return
            }
            
            let sum = statistics.averageQuantity()
            let avg = sum?.doubleValue(for: HKUnit.meter().unitDivided(by: HKUnit.second()))
            
            completion(avg)
        }
        self.healthStore?.execute(query1)
    }
    
    func getEnergyConsumed(completion: @escaping(Double?) -> Void) {
        guard let energyConsumed = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            fatalError("*** Unable to get the step count type ***")
        }
        
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)

        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
         
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }

        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query0 = HKStatisticsQuery(quantityType: energyConsumed, quantitySamplePredicate: today, options: .cumulativeSum) { (query, statisticsOrNil, errorOrNil) in
            
            guard let statistics = statisticsOrNil else {
                // Handle any errors here.
                return
            }
            
            let sum = statistics.sumQuantity()
            let totalCaloriesConsumed = sum?.doubleValue(for: HKUnit.largeCalorie())
            
            completion(totalCaloriesConsumed)
        }
        self.healthStore?.execute(query0)
    }
    
    func getDistance(completion: @escaping(Double?) -> Void) {
        guard let energyConsumed = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            fatalError("*** Unable to get the step count type ***")
        }
        
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)

        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
         
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }

        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query0 = HKStatisticsQuery(quantityType: energyConsumed, quantitySamplePredicate: today, options: .cumulativeSum) { (query, statisticsOrNil, errorOrNil) in
            
            guard let statistics = statisticsOrNil else {
                // Handle any errors here.
                return
            }
            
            let sum = statistics.sumQuantity()
            let distanceWalked = sum?.doubleValue(for: HKUnit.meter())
            
            completion(distanceWalked)
        }
        self.healthStore?.execute(query0)
    }

}


