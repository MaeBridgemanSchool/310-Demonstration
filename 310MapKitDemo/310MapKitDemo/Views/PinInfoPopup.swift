//
//  PinInfoPopup.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import SwiftUI

// Popup form
struct PinInfoPopup: View {
    @Binding var title: String
    @Binding var description: String
    
    // Closure that is executed when the user taps the Save button.
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                // Button that triggers the onSave closure to persist changes.
                Button("Save") {
                    onSave()
                }
            }
            .navigationTitle("Edit Pin")
        }
    }
}
