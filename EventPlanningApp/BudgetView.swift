import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var eventPlanner: EventPlanner

    @State private var totalBudget: String = ""
    
    let categories = ["All", "Venue", "Catering", "Decoration", "Entertainment", "Other"]
    
    private var currentSpend: Double {
        eventPlanner.vendors.reduce(0) { $0 + $1.amount }
    }
    

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Budget", text: $totalBudget)
                        .keyboardType(.decimalPad)
                        .padding()
                    Button("Set Budget") {
                        eventPlanner.budget.totalBudget = Double(totalBudget) ?? 0.0
                        eventPlanner.budget.currentSpend = currentSpend
                    }
                }.padding()
                Text("Total Budget: \(eventPlanner.budget.totalBudget, specifier: "%.2f")")
                Text("Total Spent: \(currentSpend, specifier: "%.2f")")
//                    .padding()

                let budget = eventPlanner.budget
                Text("\(budgetStatus(budget))")
//                    .padding()

                List {
//                    let allCategories = Array(Set(categories.map {$0.category })).sorted()
                    ForEach(categories, id: \.self) { category in
                        let categorySpend = eventPlanner.vendors.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
                        let percentage = budget.totalBudget == 0 ? 0 : categorySpend / budget.totalBudget * 100
                        HStack {
                            Text(category)
                            Spacer()
                            Text("\(categorySpend, specifier: "%.2f")")
                            Text("(\(categorySpend / budget.totalBudget * 100, specifier: "%.0f")%)")
                        }
                    }
                }
                
            }
            .padding()
            .navigationBarTitle("Budget")
        }
    }

    private var vendorCategories: [String] {
        Array(Set(eventPlanner.vendors.map { $0.category })).sorted()
    }

    private func budgetStatus(_ budget: Budget) -> String {
        let remaining = budget.totalBudget - budget.currentSpend
        if remaining > 0 {
            return "Under Budget by \(remaining)"
        } else if remaining < 0 {
            return "Over Budget by \(-remaining)"
        } else {
            return "On Budget"
        }
    }
}
