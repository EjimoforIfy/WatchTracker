//
//  ContentView.swift
//  WatchTracker Watch App
//
//  Created by Ejimofor I J (FCES) on 18/02/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State var tracker = TrackerModel() // Use @StateObject for ownership
    
    @State private var selectedCategory = "Breakfast"
    @State private var calories = 0
    @State private var waterAmount = 0.25  // default drink size
    
    let categories = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var body: some View {
        ScrollView {  // allows scrolling on watch
            VStack(spacing: 12) {
                
                // --- Totals Summary ---
                VStack(spacing: 4) {
                    Text("Calories Today")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Text("\(tracker.totalCalories)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.primary)
                    
                    Divider()
                    Text("Water Intake")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(tracker.totalWater, specifier: "%.2f") / \(tracker.dailyWaterGoal, specifier: "%.2f") L")
                        .font(.title3)
                        .bold()
                        .tint(.blue)
                }
                .multilineTextAlignment(.center)
                
                Divider().padding(.vertical, 4)
                
                
                // --- Meal Entry Section ---
                VStack(spacing: 10) {
                    Text("Add Meal").font(.headline)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    
                    Stepper(
                            value: $calories,
                            in: 0...2000,
                            step: 50){
                                Text("\(calories) kcal")
                                    .font(.title2)
                            }
                    
                    Button("Save Meal") {
                        tracker.addMeal(category: selectedCategory, calories: calories)
                        calories = 0
                    }
                    .disabled(calories == 0)
                    .buttonStyle(.borderedProminent)
                }
                
                Divider().padding(.vertical, 2)
                
                // --- Water Entry Section ---
                VStack(spacing: 10) {
                    Text("Add Water (L)")
                        .font(.headline)
                    
                    Slider(value: $waterAmount, in: 0.1...1.0, step: 0.1)
                    Text("\(waterAmount, specifier: "%.1f") L")
                        .font(.title3)
                    
                    Button("Save Drink") {
                        tracker.addHydration(amount: waterAmount)
                        waterAmount = 0.25
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle("Today")
        
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error)")
                }
            }
            tracker.resetIfNewDay()  // daily reset check
        }
    }
}

