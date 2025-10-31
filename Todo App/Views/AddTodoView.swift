//
//  AddTodoView.swift
//  Todo App
//
//  Created by Ghenadie Isacenco on 31/10/2025.
//

import SwiftUI

struct AddTodoView: View {
    // MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // MARK: - TODO NAME
                    TextField("Todo", text: $name)
                    
                    // MARK: - TODO PRIORITY
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // MARK: - SAVE BUTTON
                    Button {
                        print("Save new item")
                    } label: {
                        Text("Save")
                    } //: SAVE BUTTON
                } //: FORM
                
                Spacer()
            } //: VSTACK
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
            
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW
#Preview {
    AddTodoView()
}
