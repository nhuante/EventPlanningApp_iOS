import SwiftUI

struct BookedItemsView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    @State private var showAddVendorView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(eventPlanner.vendors, id: \.self) { vendor in
                    NavigationLink(destination: VendorDetailView(vendor: self.$eventPlanner.vendors[self.index(for: vendor)])) {
                        VStack(alignment: .leading) {
                            Text(vendor.name)
                            Text("Category: \(vendor.category)")
                                .font(.subheadline).foregroundColor(.secondary)
                            Text("Amount: \(vendor.amount, specifier: "%.2f")").font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteVendors)
            }
            .navigationBarTitle("Booked Items")
            .navigationBarItems(trailing: Button(action: {
                showAddVendorView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddVendorView) {
                AddVendorView(isPresented: self.$showAddVendorView)
            }
        }
    }

    private func deleteVendors(offsets: IndexSet) {
        eventPlanner.vendors.remove(atOffsets: offsets)
    }
    

    struct AddVendorView: View {
        @Environment(\.managedObjectContext) private var viewContext
        @Binding var isPresented: Bool
        
        @EnvironmentObject var eventPlanner: EventPlanner
        
        @State private var name: String = ""
        @State private var category: String = "Venue"
        @State private var amount: String = ""
        @State private var details: String = ""

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
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Details", text: $details)

                    Button("Save") {
                        eventPlanner.vendors.append(Vendor(name: name, category: category, amount: Double(amount) ?? 0.0, details: details))
                        isPresented = false
                    }
                }
                .navigationBarTitle("Add Vendor", displayMode: .inline)
            }
        }
    }
    
    struct VendorDetailView: View {
        @Binding var vendor: Vendor // Assuming Vendor is your Core Data entity for vendors
        
        @State private var notes: String
        
        init(vendor: Binding<Vendor>) {
            self._vendor = vendor
            self._notes = State(initialValue: vendor.wrappedValue.details)
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text(vendor.name)
                    .font(.title)
                Text("Category: \(vendor.category)")
                Text("Amount: \(vendor.amount, specifier: "%.2f")")
                TextEditor(text: $notes)
                    .frame(minHeight: 200)
                
            }
            .padding()
            .navigationBarTitle("Vendor Details")
            .navigationBarItems(trailing: Button("Save") {
                $vendor.wrappedValue.details = notes
            }
            )
        }
    }
    
    private func index(for vendor: Vendor) -> Int {
        guard let index = eventPlanner.vendors.firstIndex(of: vendor) else {
            fatalError("Selected vendor not found in array")
        }
        return index
    }


}

