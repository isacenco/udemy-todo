//
//  ContentView.swift
//  Todo App
//
//  Created by Ghenadie Isacenco on 31/10/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTIES

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var iconSettings: IconNames

    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var showingAddTodoView = false
    @State private var animatingButton = false
    
    @State private var showingSettingsView = false

    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            Text(todo.name ?? "Unknown")
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                        }
                    } //: FOR EACH
                    .onDelete(perform: deleteTodo)
                } //: LIST
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        showingSettingsView.toggle()
                    }, label: {
                        Image(systemName: "paintbrush")
                    }) //: ADD BUTTON
                        .sheet(isPresented: $showingSettingsView, content: {
                            SettingsView()
                                .environmentObject(iconSettings)
                        })
                )
                
                // MARK: - NO TODO ITEMS
                if todos.count == 0 {
                    EmptyListView()
                }
            } //: ZSTACK
            .sheet(isPresented: $showingAddTodoView, content: {
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            })
            .overlay(alignment: .bottomTrailing) {
                ZStack {
                    Group {
                        Circle()
                            .fill(.blue)
                            .opacity(animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                        Circle()
                            .fill(.blue)
                            .opacity(animatingButton ? 0.15 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animatingButton)
                    
                    Button(action: {
                        showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }) //: BUTTON ADD
                    .onAppear {
                        animatingButton.toggle()
                    }
                } //: ZSTACK
                .padding(.bottom, 15)
                .padding(.trailing, 15)
            }
        } //: NAVIGATION VIEW
    }

    // MARK: - FUNCTIONS
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


// MARK: - PREVIEW
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
