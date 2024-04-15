//
//  SettingsView.swift
//  Fitness Tracker
//
//  Created by Kastrijot Syla on 2/25/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("darkModeEnabled") var darkModeEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    Button("Clear All Data", role: .destructive) {
                        clearAllData()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    // Function to clear all data
    private func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "notificationsEnabled")
        UserDefaults.standard.removeObject(forKey: "darkModeEnabled")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

