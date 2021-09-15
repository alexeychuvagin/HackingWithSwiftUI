//
//  AppState.swift
//  VisitedPlaces
//
//  Created by Alexey Chuvagin on 14.09.2021.
//

import MapKit
import LocalAuthentication

class AppState: ObservableObject {
    private static let storeFolder = "SavedPlaces"
    
    @Published var isUnlocked = false
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var locations = [CodableMKPointAnnotation]()
    @Published var selectedPlace: MKPointAnnotation?
    @Published var showingPlaceDetails = false
    @Published var showingEditScreen = false
    @Published var showingErrorMessage = false
    @Published var errorMessage = ""
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.errorMessage = authenticationError?.localizedDescription ?? "Something went wrong."
                        self.showingErrorMessage = true
                    }
                }
            }
        }
        else {
            // no biometrics
        }
    }
    
    func loadData() {
        let fileName = getDocumentsDirectory().appendingPathComponent(AppState.storeFolder)
        
        do {
            let data = try Data(contentsOf: fileName)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        }
        catch {
            print("Unable to load saved data.")
        }
    }
    
    func saveData() {
        let fileName = getDocumentsDirectory().appendingPathComponent(AppState.storeFolder)
        
        do {
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        }
        catch {
            print("Unable to save data.")
        }
    }
}
