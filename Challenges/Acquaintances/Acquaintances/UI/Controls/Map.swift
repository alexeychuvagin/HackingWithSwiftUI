//
//  Map.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 20.09.2021.
//

import SwiftUI
import MapKit

struct Map: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var showsUserLocation: Bool
    var annotations: [MKPointAnnotation] = []
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: Map
        
        init(_ parent: Map) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            parent.showsUserLocation = false
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if !mapView.showsUserLocation {
                parent.centerCoordinate = mapView.centerCoordinate
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // this is our unique identifier for view reuse
            let identifier = "Acquaintance"
            
            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView != nil {
                // we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            else {
                // we didn't find one; make a new one
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // allow this to show pop up information
                annotationView?.canShowCallout = true
            }
            
            return annotationView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setCenter(centerCoordinate, animated: false)
        mapView.showsUserLocation = showsUserLocation
        mapView.addAnnotations(annotations)

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = showsUserLocation
        
        if (showsUserLocation) {
            view.setCenter(centerCoordinate, animated: true)
        }
        
//        if annotations.count != view.annotations.count {
//            view.removeAnnotations(view.annotations)
//            view.addAnnotations(annotations)
//        }
    }
}

struct MapControl_Previews: PreviewProvider {
    static var previews: some View {
        Map(
            centerCoordinate: .constant(CLLocationCoordinate2D()),
            showsUserLocation: .constant(false)
        )
    }
}
