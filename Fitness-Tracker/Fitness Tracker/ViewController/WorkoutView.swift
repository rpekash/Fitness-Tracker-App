//
//  WorkoutView.swift
//  Workout Tracker
//
//  Created by Kastrijot Syla on 4/1/24.
//
import SwiftUI

struct Workout: Identifiable, Codable {
    var id = UUID()
    var name: String
    var reps: Int
    var sets: Int
    var date: Date
}

struct WorkoutView: View {
    @State private var workoutDate = Date()
    @State private var workoutName: String = ""
    @State private var numberOfReps: String = ""
    @State private var numberOfSets: String = ""
    @State private var workouts: [Workout] = [] {
        didSet {
            saveWorkouts()
        }
    }

    // Load workouts from UserDefaults
    private func loadWorkouts() {
        if let data = UserDefaults.standard.data(forKey: "workouts"),
           let savedWorkouts = try? JSONDecoder().decode([Workout].self, from: data) {
            self.workouts = savedWorkouts
        }
    }

    // Save workouts to UserDefaults
    private func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: "workouts")
        }
    }
    
    // Helper method to format and sort the grouped workouts for ForEach
    private func sortedWorkoutGroups() -> [(key: Date, value: [Workout])] {
        let groupedWorkouts = Dictionary(grouping: workouts) { workout in
            Calendar.current.startOfDay(for: workout.date)
        }
        return groupedWorkouts.sorted { $0.key > $1.key }
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Workout")) {
                    DatePicker("Workout Date", selection: $workoutDate, displayedComponents: .date)
                    TextField("Workout Name", text: $workoutName)
                    TextField("Number of Reps", text: $numberOfReps)
                        .keyboardType(.numberPad)
                    TextField("Number of Sets", text: $numberOfSets)
                        .keyboardType(.numberPad)
                    Button("Add Workout") {
                        addWorkout()
                    }
                }

                ForEach(sortedWorkoutGroups(), id: \.key) { date, workouts in
                    Section(header: Text("\(date, style: .date)")) {
                        ForEach(workouts) { workout in
                            VStack(alignment: .leading) {
                                Text(workout.name).font(.headline)
                                Text("Reps: \(workout.reps), Sets: \(workout.sets)")
                            }
                        }
                        .onDelete { offsets in
                            deleteWorkouts(date: date, at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Workout Tracker")
            .onAppear(perform: loadWorkouts)
        }
    }

    private func addWorkout() {
        guard let reps = Int(numberOfReps), let sets = Int(numberOfSets), !workoutName.isEmpty else {
            return // Validation failed
        }
        let newWorkout = Workout(name: workoutName, reps: reps, sets: sets, date: workoutDate)
        workouts.append(newWorkout)
        workoutName = "" // Reset for next entry
        numberOfReps = ""
        numberOfSets = ""
    }
    
    private func deleteWorkouts(date: Date, at offsets: IndexSet) {
        withAnimation {
            let allWorkoutsForDate = workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            for index in offsets {
                if let toRemoveIndex = workouts.firstIndex(where: { $0.id == allWorkoutsForDate[index].id }) {
                    workouts.remove(at: toRemoveIndex)
                }
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
