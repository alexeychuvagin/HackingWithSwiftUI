//
//  ContentView.swift
//  VisitedPlaces
//
//  Created by Alexey Chuvagin on 12.09.2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var state: AppState
    
    var body: some View {
        
        Group {
            switch state.isUnlocked {
            case true:
                VisitedPlacesView()
            case false:
                AuthenticationView()
            }
        }
        .alert(isPresented: $state.showingErrorMessage) {
            Alert(
                title: Text("Error"),
                message: Text(self.state.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        state.isUnlocked = false
        
        return ContentView()
            .environmentObject(state)
    }
}
