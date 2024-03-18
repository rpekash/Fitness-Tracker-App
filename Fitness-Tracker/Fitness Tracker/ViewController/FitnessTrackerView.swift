//
//  FitnessTrackerView.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 2/14/24.
//
import SwiftUI

struct FitnessTrackerView: View {
    // State to control navigation
    @State private var isBodyWeightNavigate = false
    @State private var isMarcoNavigate = false
    @State private var isWorkoutNavigate = false
    @State private var isSettingsNavigate = false


    var body: some View {
        NavigationStack {
            VStack {
                // Invisible NavigationLink that will be activated by the state variable
                NavigationLink(destination: BodyWeightViewRepresentable(), isActive: $isBodyWeightNavigate) {
                    EmptyView()
                }

                
                
                // BodyWeightTracker BUTTON:

                // Button that when tapped, changes the state and activates the NavigationLink
                Button(action: {
                    isBodyWeightNavigate = true
                }) {
                    // Scale button content here
                    Image("scale")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        
                }
                
                // MarcoTracker BUTTON:

                NavigationLink(destination: MacrosView(), isActive: $isMarcoNavigate) {
                    EmptyView()
                }
                
                // Button that when tapped, changes the state and activates the NavigationLink
                Button(action: {
                    isMarcoNavigate = true
                }) {
                    // Scale button content here
                    Image("Marcos")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.blue)
                     
                }

                // WorkoutTracker BUTTON:
                
                NavigationLink(destination: WorkoutView(), isActive: $isWorkoutNavigate) {
                    EmptyView()
                }
                
                // Button that when tapped, changes the state and activates the NavigationLink
                Button(action: {
                    isWorkoutNavigate = true
                }) {
                    // Scale button content here
                    Image("Workout")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
                
                // Settings BUTTON:
                
                NavigationLink(destination: SettingsView(), isActive: $isSettingsNavigate) {
                    EmptyView()
                }
                
                // Button that when tapped, changes the state and activates the NavigationLink
                Button(action: {
                    isSettingsNavigate = true
                }) {
                    // Scale button content here
                    Image("Settings")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
            }
            
            .padding()
        }
    }
}

//Preview
struct FitnessTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTrackerView()
    }
}
