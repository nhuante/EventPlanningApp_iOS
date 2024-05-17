import SwiftUI

struct BookedItemsView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    @State private var showAddVendorView = false
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?

    var body: some View {
        NavigationView {
            List {
                ForEach(eventPlanner.vendors, id: \.self) { vendor in
                    NavigationLink(destination: VendorDetailView(vendor: self.$eventPlanner.vendors[self.index(for: vendor)])) {
                        VStack(alignment: .leading) {
                            Text(vendor.name)
                                .font(.headline)
                            Text("Category: \(vendor.category)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Amount: \(vendor.amount, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onDelete { indexSet in
                    indexSetToDelete = indexSet
                    showDeleteConfirmation = true
                }
            }
            .navigationBarTitle("Booked Items")
            .navigationBarItems(trailing: Button(action: {
                showAddVendorView.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $showAddVendorView) {
                AddVendorView(isPresented: self.$showAddVendorView)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Vendor"),
                    message: Text("Are you sure you want to delete this vendor?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let indexSet = indexSetToDelete {
                            deleteVendors(at: indexSet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func deleteVendors(at offsets: IndexSet) {
        eventPlanner.vendors.remove(atOffsets: offsets)
    }

    private func index(for vendor: Vendor) -> Int {
        guard let index = eventPlanner.vendors.firstIndex(of: vendor) else {
            fatalError("Selected vendor not found in array")
        }
        return index
    }
}

struct AddVendorView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var eventPlanner: EventPlanner
    
    @State private var name: String = ""
    @State private var category: String = "Venue"
    @State private var amount: String = ""
    @State private var details: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let categories = ["Venue", "Catering", "Decoration", "Entertainment", "Other"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                TextField("Details", text: $details)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button("Save") {
                    saveVendor()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.top)
            }
            .navigationBarTitle("Add Vendor", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveVendor() {
        guard let amountValue = Double(amount) else {
            alertMessage = "Please enter a valid amount."
            showAlert = true
            return
        }
        
        eventPlanner.vendors.append(Vendor(name: name, category: category, amount: amountValue, details: details))
        isPresented = false
    }
}

struct VendorDetailView: View {
    @Binding var vendor: Vendor
    
    @State private var notes: String
    
    init(vendor: Binding<Vendor>) {
        self._vendor = vendor
        self._notes = State(initialValue: vendor.wrappedValue.details)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(vendor.name)
                .font(.title)
                .padding(.bottom, 5)
            Text("Category: \(vendor.category)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Amount: \(vendor.amount, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            TextEditor(text: $notes)
                .frame(minHeight: 200)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding()
        .navigationBarTitle("Vendor Details")
        .navigationBarItems(trailing: Button("Save") {
            vendor.details = notes
        })
    }
}
