//
//  EditView.swift
//  VisitedPlaces
//
//  Created by Alexey Chuvagin on 13.09.2021.
//

import SwiftUI
import MapKit

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placemark.wrappedTitle)
                    TextField("Description", text: $placemark.wrappedSubtitle)
                }
                
                Section(header: Text("Nearby...")) {
                    switch loadingState {
                    case .loaded:
                        List(pages, id: \.pageId) { page in
                            VStack(alignment: .leading) {
                                Text(page.title)
                                    .font(.headline)
                                Text("Page description here")
                                    .font(.subheadline)
                                    .italic()
                            }
                        }
                    case .loading:
                        Text("Loading…")
                    default:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                WikipediaApi.shared.fetchNearbyPlaces(
                    longitude: placemark.coordinate.longitude,
                    latitude: placemark.coordinate.latitude
                ) { pages in
                    self.pages = pages
                    self.loadingState = LoadingState.loaded
                }
                onError: { _ in
                    self.loadingState = LoadingState.failed
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placemark: MKPointAnnotation.example)
    }
}
