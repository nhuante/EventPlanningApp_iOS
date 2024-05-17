import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    @State private var totalBudget: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.leading)
                    
                    Button(action: setBudget) {
                        Text("Set Budget")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.trailing)
                    }
                }
                .padding(.vertical)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Budget: \(eventPlanner.budget.totalBudget, specifier: "%.2f")")
                        .font(.headline)
                    Text("Total Spent: \(currentSpend, specifier: "%.2f")")
                        .font(.headline)
                    Text(budgetStatus())
                        .font(.headline)
                        .foregroundColor(budgetStatusColor())
                }
                .padding()
                
                List {
                    ForEach(categories, id: \.self) { category in
                        let categorySpend = eventPlanner.vendors.filter { $0.category == category || category == "All" }.reduce(0) { $0 + $1.amount }
                        let percentage = eventPlanner.budget.totalBudget == 0 ? 0 : categorySpend / eventPlanner.budget.totalBudget * 100
                        HStack {
                            Text(category)
                            Spacer()
                            Text("\(categorySpend, specifier: "%.2f")")
                            Text("(\(percentage, specifier: "%.0f")%)")
                                .foregroundColor(percentageColor(percentage))
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("Budget")
        }
    }
    
    private func setBudget() {
        guard let budget = Double(totalBudget) else {
            alertMessage = "Please enter a valid budget amount."
            showAlert = true
            return
        }
        eventPlanner.budget.totalBudget = budget
        eventPlanner.budget.currentSpend = currentSpend
    }
    
    private func budgetStatus() -> String {
        let remaining = eventPlanner.budget.totalBudget - currentSpend
        if remaining > 0 {
            return "Under Budget by \(String(format: "%.2f", remaining))"
        } else if remaining < 0 {
            return "Over Budget by \(String(format: "%.2f", -remaining))"
        } else {
            return "On Budget"
        }
    }
    
    private func budgetStatusColor() -> Color {
        let remaining = eventPlanner.budget.totalBudget - currentSpend
        if remaining > 0 {
            return .green
        } else if remaining < 0 {
            return .red
        } else {
            return .orange
        }
    }
    
    private func percentageColor(_ percentage: Double) -> Color {
        switch percentage {
        case ..<50:
            return .green
        case 50..<75:
            return .orange
        case 75...:
            return .red
        default:
            return .primary
        }
    }
}
