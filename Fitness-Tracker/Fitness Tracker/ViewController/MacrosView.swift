//
//  MacrosView.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 2/22/24.
//
import SwiftUI

// Model for the macros
struct Macros: Codable {
    var calories: Int
    var fat: Double
    var protein: Double
    var fiber: Double
}

// Model for each meal
struct Meal: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var macros: Macros
}

// View model for managing and storing meals
class MealManager: ObservableObject {
    @Published var meals: [Meal] = []
    
    init() {
        loadMeals()
    }
    
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        saveMeals()
    }
    
    func deleteMeal(at indexSet: IndexSet) {
        meals.remove(atOffsets: indexSet)
        saveMeals()
    }
    
    func loadMeals() {
        if let data = UserDefaults.standard.data(forKey: "Meals"),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            meals = decoded
        }
    }
    
    func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "Meals")
        }
    }

    func totalMacros(for date: Date) -> Macros {
        let calendar = Calendar.current
        return meals.filter { calendar.isDate($0.date, inSameDayAs: date) }
            .reduce(Macros(calories: 0, fat: 0, protein: 0, fiber: 0)) { total, meal in
                Macros(calories: total.calories + meal.macros.calories,
                       fat: total.fat + meal.macros.fat,
                       protein: total.protein + meal.macros.protein,
                       fiber: total.fiber + meal.macros.fiber)
            }
    }
}

// SwiftUI view for the macro tracker
struct MacrosView: View {
    @ObservedObject var mealManager = MealManager()
    @State private var mealName: String = ""
    @State private var calories: Int = 0
    @State private var fat: Double = 0
    @State private var protein: Double = 0
    @State private var fiber: Double = 0
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding()

                dailyTotalView
                
                Form {
                    TextField("Meal Name", text: $mealName)
                    TextField("Calories", value: $calories, formatter: NumberFormatter())
                    TextField("Fat in grams", value: $fat, formatter: NumberFormatter())
                    TextField("Protein in grams", value: $protein, formatter: NumberFormatter())
                    TextField("Fiber in grams", value: $fiber, formatter: NumberFormatter())
                    Button("Add Meal") {
                        let newMeal = Meal(name: mealName, date: selectedDate, macros: Macros(calories: calories, fat: fat, protein: protein, fiber: fiber))
                        mealManager.addMeal(newMeal)
                        clearForm()
                    }
                }

                List {
                    ForEach(mealManager.meals.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { meal in
                        VStack(alignment: .leading) {
                            Text(meal.name).font(.headline)
                            Text("Calories: \(meal.macros.calories)")
                            Text("Fat: \(meal.macros.fat)g")
                            Text("Protein: \(meal.macros.protein)g")
                            Text("Fiber: \(meal.macros.fiber)g")
                        }
                    }
                    .onDelete(perform: mealManager.deleteMeal)
                }
            }
            .navigationTitle("Macro Tracker")
        }
    }

    private var dailyTotalView: some View {
        let totals = mealManager.totalMacros(for: selectedDate)
        return Group {
            Text("Daily Totals").font(.headline).padding()
            Text("Calories: \(totals.calories)")
            Text("Fat: \(totals.fat, specifier: "%.1f")g")
            Text("Protein: \(totals.protein, specifier: "%.1f")g")
            Text("Fiber: \(totals.fiber, specifier: "%.1f")g")
        }
    }
    
    private func clearForm() {
        mealName = ""
        calories = 0
        fat = 0
        protein = 0
        fiber = 0
    }
}

// Preview provider for SwiftUI previews
struct MacrosView_Previews: PreviewProvider {
    static var previews: some View {
        MacrosView()
    }
}
