//
//  PinInfoPopup.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import SwiftUI

struct PinInfoPopup: View {
    @Binding var title: String
    @Binding var description: String
    
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                Button("Save") {
                    onSave()
                }
            }
            .navigationTitle("Edit Pin")
        }
    }
}
