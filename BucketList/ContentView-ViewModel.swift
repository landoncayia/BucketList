//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Landon Cayia on 8/24/22.
//

import Foundation
import MapKit

extension ContentView {
    // Generally, ObservableObject classes should always be marked with @MainActor
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations = [Location]()
        
        // Optional because a location may or may not be selected
        @Published var selectedPlace: Location?
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            
            // Find previous location, replace with new one
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }
    }
}
