import SwiftUI

struct MainView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    
    var body: some View {
        TabView {
            TodoListView()
                .tabItem {
                    Label("To Do", systemImage: "checklist")
                }
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
            BookedItemsView()
                .tabItem {
                    Label("Booked", systemImage: "calendar")
                }
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "dollarsign.circle")
                }
        }
        .onAppear {
            autopopulateData()
        }
    }
    
    func autopopulateData() {
        // Autopopulate notes
        eventPlanner.notes.append(contentsOf: [
            Note(name: "Note 1", content: "Content of Note 1 Notes for Task 1 this one will be relatively short"),
            Note(name: "Note 2", content: "Notes for Task 2 okay i have to make this one longer because i need to test if the cutoff for limiting the characters shown in the list view is actually working yaysydycsidsjkn kjshkjsdhbksjkshuiwalscdnaoshde aouwjna")
        ])
        
        // Autopopulate todo items
        eventPlanner.todoItems.append(contentsOf: [
            TodoItem(name: "Task 1", category: "venue", budget: 100.0, notes: "Notes for Task 1 this one will be relatively short"),
            TodoItem(name: "Task 2", category: "decorations", budget: 150.0, notes: "Notes for Task 2 okay i have to make this one longer because i need to test if the cutoff for limiting the characters shown in the list view is actually working yaysydycsidsjkn kjshkjsdhbksjkshuiwalscdnaoshde aouwjna")
        ])
    
        // Autopopulate budget
        eventPlanner.budget = Budget(totalBudget: 5000.0, currentSpend: 0.0)
        
        // Autopopulate vendors
        eventPlanner.vendors.append(contentsOf: [
            Vendor(name: "Vendor 1", category: "Venue", amount: 500.0, details: "Details of Vendor 1"),
            Vendor(name: "Vendor 2", category: "Decoration", amount: 750.0, details: "Details of Vendor 2")
        ])
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(EventPlanner())
    }
}
