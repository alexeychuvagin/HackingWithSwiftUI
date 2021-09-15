//
//  BucketListApp.swift
//  Bucket List
//
//  Created by Alexey Chuvagin on 12.09.2021.
//

import SwiftUI

@main
struct BucketListApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
