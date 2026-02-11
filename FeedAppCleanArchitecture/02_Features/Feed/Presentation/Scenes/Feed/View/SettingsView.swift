//
//  SettingsView.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        List {
            Section("Account") {
                NavigationLink("Profile") {
                    Text("Profile Settings")
                }
                
                NavigationLink("Privacy") {
                    Text("Privacy Settings")
                }
            }
            
            Section("App") {
                NavigationLink("Notifications") {
                    Text("Notification Settings")
                }
                
                NavigationLink("Appearance") {
                    Text("Appearance Settings")
                }
            }
            
            Section {
                Button("Sign Out", role: .destructive) {
                    // Sign out action
                }
            }
        }
        .navigationTitle("Settings")
    }
}
