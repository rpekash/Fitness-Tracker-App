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
    @Published var searchText = ""
    
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
    
    func filteredMeals() -> [Meal] {
        if searchText.isEmpty {
            return meals
        } else {
            return meals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
    @State private var calories: String = ""
    @State private var fat: String = ""
    @State private var protein: String = ""
    @State private var fiber: String = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding()

                dailyTotalView
                
                Form {
                    TextField("Meal Name", text: $mealName)
                    TextField("Calories", text: $calories)
                    TextField("Fat in grams", text: $fat)
                    TextField("Protein in grams", text: $protein)
                    TextField("Fiber in grams", text: $fiber)
                    Button("Add Meal") {
                        if let cal = Int(calories), let f = Double(fat), let pro = Double(protein), let fib = Double(fiber) {
                            let newMeal = Meal(name: mealName, date: selectedDate, macros: Macros(calories: cal, fat: f, protein: pro, fiber: fib))
                            mealManager.addMeal(newMeal)
                            clearForm()
                        }
                    }
                }

                SearchBar(text: $mealManager.searchText)

                List {
                    ForEach(mealManager.filteredMeals().filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { meal in
                        VStack(alignment: .leading) {
                            Text(meal.name).font(.headline)
                            Text("Calories: \(meal.macros.calories)")
                            Text("Fat: \(formatMacro(meal.macros.fat))g")
                            Text("Protein: \(formatMacro(meal.macros.protein))g")
                            Text("Fiber: \(formatMacro(meal.macros.fiber))g")
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
            Text("Fat: \(formatMacro(totals.fat))g")
            Text("Protein: \(formatMacro(totals.protein))g")
            Text("Fiber: \(formatMacro(totals.fiber))g")
        }
    }
    
    private func formatMacro(_ value: Double) -> String {
        String(format: "%.1f", value)
    }
    
    private func clearForm() {
        mealName = ""
        calories = ""
        fat = ""
        protein = ""
        fiber = ""
    }
}

// SwiftUI view for a search bar
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search meals...", text: $text)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
    }
}

// Preview provider for SwiftUI previews
struct MacrosView_Previews: PreviewProvider {
    static var previews: some View {
        MacrosView()
    }
}
