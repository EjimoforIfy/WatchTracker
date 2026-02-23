import SwiftUI
import Foundation
import Combine
import Observation
import UserNotifications

@Observable
class TrackerModel {
    var meals: [Meal] = []
    var hydrationEntries: [Hydration] = []
    var totalCalories: Int = 0
    var totalWater: Double = 0.0
    var dailyWaterGoal: Double = 2.0
    
    private let defaults = UserDefaults.standard
    
    var yesterdayWater: Double {
        get { defaults.double(forKey: "yesterdayWater") }
        set { defaults.set(newValue, forKey: "yesterdayWater") }
    }
    
    private var totalWaterAllTime: Double {
        get { defaults.double(forKey: "totalWaterAllTime") }
        set { defaults.set(newValue, forKey: "totalWaterAllTime") }
    }
    
    private var daysTracked: Int {
        get { defaults.integer(forKey: "daysTracked") }
        set { defaults.set(newValue, forKey: "daysTracked") }
    }
    
    var averageDailyWater: Double {
        daysTracked > 0 ? totalWaterAllTime / Double(daysTracked) : 0.0
    }
    
    func addMeal(category: String, calories: Int) {
        meals.append(Meal(category: category, calories: calories, timestamp: Date()))
        totalCalories += calories
    }
    
    func addHydration(amount: Double) {
        hydrationEntries.append(Hydration(amountLitres: amount, timestamp: Date()))
        totalWater += amount
    }
    
    func updateHistoricalData() {
        yesterdayWater = totalWater
        totalWaterAllTime += totalWater
        daysTracked += 1
        totalWater = 0.0
        totalCalories = 0
        meals.removeAll()
        hydrationEntries.removeAll()
    }
    
    func resetIfNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        if let lastReset = defaults.object(forKey: "lastResetDate") as? Date,
           !Calendar.current.isDate(today, inSameDayAs: lastReset) {
            updateHistoricalData()
            defaults.set(today, forKey: "lastResetDate")
        }
    }
    
    // MARK: - Nested types
    struct Meal: Identifiable, Codable {
        var id = UUID()
        let category: String
        let calories: Int
        let timestamp: Date
    }
    
    struct Hydration: Identifiable, Codable {
        var id = UUID()
        let amountLitres: Double
        let timestamp: Date
    }
}


