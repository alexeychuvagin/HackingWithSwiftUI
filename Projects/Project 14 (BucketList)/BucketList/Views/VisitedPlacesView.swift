//
//  VisitedPlacesView.swift
//  VisitedPlaces
//
//  Created by Alexey Chuvagin on 14.09.2021.
//

import SwiftUI

struct VisitedPlacesView: View {
    @EnvironmentObject private var state: AppState
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $state.centerCoordinate, selectedPlace: $state.selectedPlace, showingPlaceDetails: $state.showingPlaceDetails, annotations: state.locations)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Create a new location
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.coordinate = self.state.centerCoordinate
                        newLocation.title = "Title"
                        newLocation.subtitle = "Description"
                        self.state.locations.append(newLocation)
                        self.state.selectedPlace = newLocation
                        self.state.showingEditScreen = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
        }
        .actionSheet(isPresented: $state.showingPlaceDetails) {
            ActionSheet(
                title: Text(state.selectedPlace?.title ?? "Unknown"),
                message: Text(state.selectedPlace?.subtitle ?? "Missing place information."),
                buttons: [
                    .default(Text("Edit")) { self.state.showingEditScreen = true },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $state.showingEditScreen, onDismiss: state.saveData) {
            if self.state.selectedPlace != nil {
                EditView(placemark: self.state.selectedPlace!)
            }
        }
        .onAppear(perform: state.loadData)
    }
}

struct VisitedPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        VisitedPlacesView()
            .environmentObject(AppState())
    }
}
