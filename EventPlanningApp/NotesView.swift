import SwiftUI

struct NotesView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    @State private var showAddNoteView = false
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(eventPlanner.notes, id: \.self) { note in
                        NavigationLink(destination: NoteDetailView(note: self.$eventPlanner.notes[self.index(for: note)])) {
                            NoteListItemView(note: note)
                        }
                    }
                    .onDelete { indexSet in
                        indexSetToDelete = indexSet
                        showDeleteConfirmation = true
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                showAddNoteView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddNoteView) {
                AddNoteView(isPresented: self.$showAddNoteView)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Note"),
                    message: Text("Are you sure you want to delete this note?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let indexSet = indexSetToDelete {
                            deleteNotes(at: indexSet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        eventPlanner.notes.remove(atOffsets: offsets)
    }

    private func index(for note: Note) -> Int {
        guard let index = eventPlanner.notes.firstIndex(of: note) else {
            fatalError("Selected note not found in array")
        }
        return index
    }
}

struct NoteListItemView: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.name)
                .font(.headline)
            Text(trimmedContent(note.content))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
        .accessibilityElement(children: .combine)
        .accessibility(label: Text("\(note.name), \(trimmedContent(note.content))"))
    }

    private func trimmedContent(_ content: String) -> String {
        let lines = content.split(separator: "\n")
        if let firstLine = lines.first {
            return String(firstLine.prefix(50))
        } else {
            return ""
        }
    }
}

struct AddNoteView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var eventPlanner: EventPlanner
    
    @State private var content: String = ""
    @State private var name: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Note Name", text: $name)
                TextField("Note Content", text: $content)

                Button("Save") {
                    eventPlanner.notes.append(Note(name: name, content: content))
                    isPresented = false
                }
            }
            .navigationBarTitle("Add Note", displayMode: .inline)
        }
    }
}

struct NoteDetailView: View {
    @Binding var note: Note
    
    @State private var content: String
    
    init(note: Binding<Note>) {
        self._note = note
        self._content = State(initialValue: note.wrappedValue.content)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $content)
                .frame(minHeight: 200)
                .padding()
        }
        .navigationBarTitle("Note Details", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            note.content = content
        })
        .onAppear {
            self.content = note.content
        }
    }
}
