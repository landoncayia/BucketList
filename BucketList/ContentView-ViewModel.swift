//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Landon Cayia on 8/24/22.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    // Generally, ObservableObject classes should always be marked with @MainActor
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        // Optional because a location may or may not be selected
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        @Published var showingAuthenticationAlert = false
        @Published var authenticationError = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            
            // Find previous location, replace with new one
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        // biometric authentication error
                        Task { @MainActor in
                            self.authenticationError = "\(authenticationError?.localizedDescription ?? "Unknown error.")"
                            self.showingAuthenticationAlert = true
                        }
                    }
                }
            } else {
                // no biometrics available
                Task { @MainActor in
                    self.authenticationError = "Neither Touch ID nor Face ID are available on this device."
                    self.showingAuthenticationAlert = true
                }
            }
        }
    }
}
