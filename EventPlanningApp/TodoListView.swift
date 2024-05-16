import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    
    @State private var showAddTodoView = false
    @State private var selectedCategory: String = "All"
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
                HStack{
                    Text("Filter Category: ")
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }.pickerStyle(.menu)
                }
                List {
                    ForEach(filteredTodoItems, id: \.self) { todoItem in
                        NavigationLink(destination: TodoDetailView(todoItem: self.$eventPlanner.todoItems[self.index(for: todoItem)])) {
                            VStack(alignment: .leading) {
                                Text(todoItem.name)
                                Text(todoItem.category).font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteTodoItems)
                }
                .navigationBarTitle("To Do List")
                .navigationBarItems(trailing: Button(action: {
                    showAddTodoView.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showAddTodoView) {
                    AddTodoView(isPresented: self.$showAddTodoView)
                }
            }
        }
    }

    private func deleteTodoItems(offsets: IndexSet) {
        eventPlanner.todoItems.remove(atOffsets: offsets)
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
            }
            .padding()
            .navigationBarTitle("To Do Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                $todoItem.wrappedValue.notes = notes
            }
            )
        }
    }
    

    struct AddTodoView: View {
        @Environment(\.managedObjectContext) private var viewContext
        @Binding var isPresented: Bool
        
        @EnvironmentObject var eventPlanner: EventPlanner
        
        @State private var name: String = ""
        @State private var category: String = "Venue"
        @State private var budget: String = ""
        @State private var notes: String = ""
        
        let categories = ["Venue", "Catering", "Decoration", "Entertainment"]

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
                        eventPlanner.todoItems.append(TodoItem(name: name, category: category, budget: Double(budget) ?? 0.0, notes: notes))
                        isPresented = false
                    }
                }
                .navigationBarTitle("Add To-Do", displayMode: .inline)
            }
        }
    }

    private func index(for todoItem: TodoItem) -> Int {
        guard let index = eventPlanner.todoItems.firstIndex(of: todoItem) else {
            fatalError("Selected vendor not found in array")
        }
        return index
    }

}
