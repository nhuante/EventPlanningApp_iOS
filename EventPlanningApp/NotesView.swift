import SwiftUI

struct NotesView: View {
    @EnvironmentObject var eventPlanner: EventPlanner
    @State private var showAddNoteView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(eventPlanner.notes, id: \.self) { note in
                        NavigationLink(destination: NoteDetailView(note: self.$eventPlanner.notes[self.index(for: note)])) {
                            NoteListItemView(note: note)
                        }
                    }
                    .onDelete(perform: deleteNotes)
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
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        eventPlanner.notes.remove(atOffsets: offsets)
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
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
        }

        private func trimmedContent(_ content: String) -> String {
            let lines = content.split(separator: "\n")
            if let firstLine = lines.first {
                return String(firstLine.prefix(50)) // Adjust the length as needed
            } else {
                return ""
            }
        }
    }
    

    struct AddNoteView: View {
        @Environment(\.managedObjectContext) private var viewContext
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
        
        // State variables for editing
        @State private var content: String
        
        init(note: Binding<Note>) {
            self._note = note
            // Initialize state variables with the current values
            self._content = State(initialValue: note.wrappedValue.content)
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
            }
            .padding()
            .navigationBarTitle("Note Details", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Save") {
                    // Save changes to the note
                    $note.wrappedValue.content = content
                }
            )
        }
    }
    
    private func index(for note: Note) -> Int {
        guard let index = eventPlanner.notes.firstIndex(of: note) else {
            fatalError("Selected note not found in array")
        }
        return index
    }
}
