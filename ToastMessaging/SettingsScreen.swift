//
//  SettingsScreen.swift
//  ToastMessaging
//
//  Created by Brian Simmons on 6/3/25.
//


import SwiftUI

struct SettingsScreen: View {
    @State private var isNotificationsOn = true
    @State private var isDarkModeOn = false
    
    @Environment(\.showToast) private var showToast
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("john@example.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $isNotificationsOn)
                    Toggle("Dark Mode", isOn: $isDarkModeOn)
                }
                
                Section {
                    Button(role: .destructive) {
                        showToast(.info("You are signed out."))
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsScreen()
}