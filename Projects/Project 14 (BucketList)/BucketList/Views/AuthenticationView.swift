//
//  AuthenticationView.swift
//  VisitedPlaces
//
//  Created by Alexey Chuvagin on 12.09.2021.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Button("Unlock", action: appState.authenticate)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AppState())
    }
}
