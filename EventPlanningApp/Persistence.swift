import CoreData

struct PersistentController {
    static let shared = PersistentController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "PartyPlanner")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
}
