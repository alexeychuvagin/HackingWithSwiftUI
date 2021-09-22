//
//  AcquaintancesApp.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 16.09.2021.
//

import SwiftUI
import Resolver

@main
struct AcquaintancesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { AcquaintancesInMemoryRepository() }.implements(AcquaintancesRepository.self).scope(.shared)
        register { DeviceLocationFetcher() }.implements(LocationFetcher.self).scope(.shared)
    }
}
