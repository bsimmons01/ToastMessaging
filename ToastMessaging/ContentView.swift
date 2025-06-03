//
//  ContentView.swift
//  ToastMessaging
//
//  Created by Brian Simmons on 6/3/25.
//

import SwiftUI

enum ToastType {
  case success(String)
  case error(String)
  case info(String)

  var backgroundColor: Color {
    switch self {
    case .success:
      return Color.green.opacity(0.9)
    case .error:
      return Color.red.opacity(0.9)
    case .info:
      return Color.blue.opacity(0.9)
    }
  }

  var icon: Image {
    switch self {
    case .success:
      return Image(systemName: "checkmark.circle")
    case .error:
      return Image(systemName: "xmark.octagon")
    case .info:
      return Image(systemName: "info.circle")
    }
  }

  var message: String {
    switch self {
    case .success(let message):
      return message
    case .error(let message):
      return message
    case .info(let message):
      return message
    }
  }
}

struct ToastView: View {
  let type: ToastType

  var body: some View {
    HStack(alignment: .center, spacing: 10) {
      type.icon
        .foregroundStyle(.white)
      Text(type.message)
        .foregroundColor(.white)
        .font(.subheadline)
        .multilineTextAlignment(.leading)
    }
    .padding()
    .background(type.backgroundColor)
    .cornerRadius(12)
    .shadow(radius: 4)
    .padding(.horizontal, 16)
  }
}

#Preview {
  ToastView(type: .success("Action saved"))
  ToastView(type: .error("Action failed"))
  ToastView(type: .info("Info message"))
}

struct ShowToastAction {
  typealias Action = (ToastType) -> Void
  let action: Action

  func callAsFunction(_ type: ToastType) {
    action(type)
  }
}

extension EnvironmentValues {
  @Entry var showToast = ShowToastAction(action:  { _ in })
}

struct ToastModifier: ViewModifier {
  @State private var type: ToastType?
  @State private var dismissTask: DispatchWorkItem?

  func body(content: Content) -> some View {
    content
      .environment(\.showToast, ShowToastAction(action: { type in
          withAnimation(.easeInOut) {
            self.type = type
          }
        // cancel previous dismissal task if any
        dismissTask?.cancel()

        // schedule a new dismissal
        let task = DispatchWorkItem {
          withAnimation(.easeInOut) {
            self.type = nil
          }
        }

        self.dismissTask = task

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
      }))
      .overlay(alignment: .top) {
        if let type {
          ToastView(type: type)
            .transition(.move(edge: .top).combined(with: .opacity))
            .padding(.top, 50)
        }
      }
  }
}

extension View {
  func withToast() -> some View {
    modifier(ToastModifier())
  }
}


struct ContentView: View {
  @Environment(\.showToast) private var showToast
  @State private var settingsPresented: Bool = false

  var body: some View {
    VStack {
      Button("Error") {
        showToast(.error("Operation failed."))
      }

      Button("Show Settings") {
        settingsPresented = true
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .sheet(isPresented: $settingsPresented) {
      SettingsScreen()
        .withToast()
    }

  }
}

#Preview {
    ContentView()
    .withToast()
}
