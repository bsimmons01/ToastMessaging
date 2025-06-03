//
//  ToastMessagingApp.swift
//  ToastMessaging
//
//  Created by Brian Simmons on 6/3/25.
//

import SwiftUI

@main
struct ToastMessagingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .withToast()
        }
    }
}
