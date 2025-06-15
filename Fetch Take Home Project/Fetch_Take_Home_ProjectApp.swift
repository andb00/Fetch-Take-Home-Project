//
//  Fetch_Take_Home_ProjectApp.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import SwiftUI

@main
struct Fetch_Take_Home_ProjectApp: App {
    @State var viewModel = RecipeViewModel()
    init() {
        loadRocketSimConnect()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}

private func loadRocketSimConnect() {
    #if DEBUG
    guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
        print("Failed to load linker framework")
        return
    }
    print("RocketSim Connect successfully linked")
    #endif
}
