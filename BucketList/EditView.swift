//
//  EditView.swift
//  BucketList
//
//  Created by Landon Cayia on 8/22/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.name = name
                    newLocation.description = description
                    
                    // Pass the new location back to whatever called this view
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    
    // @escaping tells Swift to keep the memory alive so that it can be called later on (when save is tapped)
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
