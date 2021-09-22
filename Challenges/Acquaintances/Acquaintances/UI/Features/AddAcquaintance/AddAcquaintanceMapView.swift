//
//  AddAcquaintanceMapView.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 20.09.2021.
//

import SwiftUI
import Resolver
import CoreLocation

struct AddAcquaintanceMapView: View {
    @Environment(\.presentationMode) var presentationMode
    @Injected var locationFecther: LocationFetcher
    @Binding var currentLocation: CLLocationCoordinate2D?
    @State var centerCoordinate: CLLocationCoordinate2D
    @State private var showUserLocation = false
    
    init(currentLocation: Binding<CLLocationCoordinate2D?>) {
        self._currentLocation = currentLocation;

        if let currentLocation = currentLocation.wrappedValue {
            self._centerCoordinate = State(initialValue: currentLocation)
        }
        else {
            self._centerCoordinate = State(initialValue: CLLocationCoordinate2D())
        }
    }
    
    var body: some View {
        ZStack {
            Map(centerCoordinate: $centerCoordinate, showsUserLocation: $showUserLocation)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    MapButton(image: Image(systemName: "location"), onClick: {
                        self.showUserLocation = true
                        self.centerCoordinate = locationFecther.getLastKnownLocation() ?? CLLocationCoordinate2D()
                    })
                }
                
                HStack {
                    Spacer()
                    MapButton(image: Image(systemName: "plus"), onClick: {
                        self.currentLocation = self.centerCoordinate
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
                .padding(.bottom, 15)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            self.locationFecther.start()
        }
        .onDisappear {
            self.locationFecther.stop()
        }
    }
}

struct AddAcquaintanceMapView_Previews: PreviewProvider {
    static var previews: some View {
        AddAcquaintanceMapView(currentLocation: .constant(CLLocationCoordinate2D.defaultLocation))
    }
}
