//
//  BodyWeightHistory.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 3/17/24.
//
import SwiftUI
import Charts

struct BodyWeightHistory: View {
    @State private var list: [WeightModel] = []
    @State private var newWeight: String = ""
    @State private var newDate = Date()
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df
    }()
    
    private let userDefaultsKey = "weightData"
    
    init() {
        _list = State(initialValue: loadWeights())
    }
    
    var body: some View {
        VStack {
            // Inputs and Add Button
            TextField("Enter new weight", text: $newWeight)
                .keyboardType(.decimalPad)
                .padding()
            DatePicker("Select Date", selection: $newDate, displayedComponents: .date)
                .padding()
            Button("Add Weight") {
                addWeight()
            }
            .padding()
            ScrollView{
                // Chart Displaying Weights
                Chart(list) { weightModel in
                    LineMark(
                        x: .value("Date", formatDate(weightModel.createAt)),
                        y: .value("Weight", weightModel.weight)
                    ).interpolationMethod(.cardinal)
                    
                    PointMark(
                        x: .value("Date", formatDate(weightModel.createAt)),
                        y: .value("Weight", weightModel.weight)
                    )
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
            
            // List for managing weights
            List {
                ForEach(list) { weightEntry in
                    Text("\(String(format: "%.2f" ,weightEntry.weight)) lbs on \(formatDate(weightEntry.createAt))")
                }
                .onDelete(perform: deleteWeight)
            }
        }
    }
    
    private func addWeight() {
        guard let weight = Double(newWeight) else { return }
        let weightEntry = WeightModel(weight: weight, createAt: newDate)
        list.append(weightEntry)
        saveWeights()
        newWeight = ""
        newDate = Date()
    }
    
    private func deleteWeight(at offsets: IndexSet) {
        list.remove(atOffsets: offsets)
        saveWeights()
    }
    
    private func loadWeights() -> [WeightModel] {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let loadedWeights = try? decoder.decode([WeightModel].self, from: savedData) {
                return loadedWeights
            }
        }
        return []
    }
    
    private func saveWeights() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        Self.dateFormatter.string(from: date)
    }
}
