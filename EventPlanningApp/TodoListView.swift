import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    
    @State private var showAddTodoView = false
    @State private var selectedCategory: String = "All"
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?
    let categories = ["All", "Venue", "Catering", "Decoration", "Entertainment", "Other"]

    var filteredTodoItems: [TodoItem] {
        if selectedCategory == "All" {
            return eventPlanner.todoItems
        } else {
            return eventPlanner.todoItems.filter { $0.category == selectedCategory }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Filter Category: ")
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()
                
                List {
                    ForEach(filteredTodoItems, id: \.self) { todoItem in
                        NavigationLink(destination: TodoDetailView(todoItem: self.$eventPlanner.todoItems[self.index(for: todoItem)])) {
                            VStack(alignment: .leading) {
                                Text(todoItem.name)
                                Text(todoItem.category)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSetToDelete = indexSet
                        showDeleteConfirmation = true
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("To Do List")
                .navigationBarItems(trailing: Button(action: {
                    showAddTodoView.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showAddTodoView) {
                    AddTodoView(isPresented: self.$showAddTodoView)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Delete To-Do Item"),
                        message: Text("Are you sure you want to delete this to-do item?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let indexSet = indexSetToDelete {
                                deleteTodoItems(at: indexSet)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }

    private func deleteTodoItems(at offsets: IndexSet) {
        eventPlanner.todoItems.remove(atOffsets: offsets)
    }

    private func index(for todoItem: TodoItem) -> Int {
        guard let index = eventPlanner.todoItems.firstIndex(of: todoItem) else {
            fatalError("Selected todo item not found in array")
        }
        return index
    }
}

struct AddTodoView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var eventPlanner: EventPlanner
    
    @State private var name: String = ""
    @State private var category: String = "Venue"
    @State private var budget: String = ""
    @State private var notes: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let categories = ["Venue", "Catering", "Decoration", "Entertainment", "Other"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                TextField("Budget", text: $budget)
                    .keyboardType(.decimalPad)
                TextField("Notes", text: $notes)

                Button("Save") {
                    saveTodoItem()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add To-Do", displayMode: .inline)
        }
    }
    
    private func saveTodoItem() {
        guard let budgetValue = Double(budget) else {
            alertMessage = "Please enter a valid budget amount."
            showAlert = true
            return
        }
        
        eventPlanner.todoItems.append(TodoItem(name: name, category: category, budget: budgetValue, notes: notes))
        isPresented = false
    }
}

struct TodoDetailView: View {
    @Binding var todoItem: TodoItem
    
    @State private var notes: String
    
    init(todoItem: Binding<TodoItem>) {
        self._todoItem = todoItem
        self._notes = State(initialValue: todoItem.wrappedValue.notes)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(todoItem.name)
                .font(.largeTitle)
            Text("Category: \(todoItem.category)")
            Text("Budget: \(todoItem.budget, specifier: "%.2f")")
            TextEditor(text: $notes)
                .frame(minHeight: 200)
                .padding()
        }
        .padding()
        .navigationBarTitle("To Do Details", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            todoItem.notes = notes
        })
        .onAppear {
            self.notes = todoItem.notes
        }
    }
}
