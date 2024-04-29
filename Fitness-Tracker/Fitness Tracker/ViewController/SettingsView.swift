import SwiftUI

enum ThemeColor: String, CaseIterable {
    case blue = "Blue"
    case green = "Green"
    case red = "Red"

    var color: Color {
        switch self {
        case .blue:
            return .blue
        case .green:
            return .green
        case .red:
            return .red
        }
    }
}

struct SettingsView: View {
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("darkModeEnabled") var darkModeEnabled: Bool = false
    @AppStorage("themeColor") private var themeColorRaw: String = ThemeColor.blue.rawValue

    var themeColor: ThemeColor {
        get { ThemeColor(rawValue: themeColorRaw) ?? .blue }
        set { themeColorRaw = newValue.rawValue }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled.animation())
                    Button("Clear All Data", role: .destructive) {
                        clearAllData()
                    }
                }
                
                Section(header: Text("Customization")) {
                    Picker("Theme Color", selection: $themeColorRaw) {
                        ForEach(ThemeColor.allCases, id: \.self) { color in
                            Text(color.rawValue).tag(color.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Support")) {
                    Button("Help & FAQs") {
                        // Action to show Help & FAQs
                    }
                    Button("Contact Us") {
                        // Action to initiate contact
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .accentColor(themeColor.color)  // Apply theme color to the navigation view accents
        .preferredColorScheme(darkModeEnabled ? .dark : .light)  // Apply dark mode setting
    }

    // Function to clear all data
    private func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "notificationsEnabled")
        UserDefaults.standard.removeObject(forKey: "darkModeEnabled")
        UserDefaults.standard.removeObject(forKey: "themeColor")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
