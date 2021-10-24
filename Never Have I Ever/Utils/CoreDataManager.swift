import UIKit
import CoreData

class DatabaseManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let shared: DatabaseManager = {
        let instance = DatabaseManager()
        return instance
    }()
    
    private init() {}
    
    func saveTask(name: String, levelId: Int, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let taskDB = TaskDB(context: managedContext)
        taskDB.name = name
        taskDB.levelId = Int16(levelId)
        taskDB.isSelected = true
        
        
        do {
            try managedContext.save()
//            Level.updateLevels()
            print("Data saved")
            completion(true)
        } catch {
            print("Failed to save data: ", error.localizedDescription)
            completion(false)
        }
    }
    
    func selectTask(_ task: TaskDB, isSelected: Bool = true) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        task.isSelected = isSelected
        do {
            try managedContext.save()
            print("Task status updated")
        } catch {
            print("Failed to update data: ", error.localizedDescription)
        }
    }
    
    func updateTasks() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        do {
            try managedContext.save()
//            Level.updateLevels()
            print("Tasks updated")
        } catch {
            print("Failed to update data: ", error.localizedDescription)
        }
    }
    
    func deleteData(task: TaskDB) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(task)
        do {
            try managedContext.save()
            print("Data deleted")
        } catch {
            print("Failed to delete data: ", error.localizedDescription)
        }
    }
    
    func getTasks(completion: (_ complete: Bool, _ tasks: [TaskDB]?) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskDB")
        do {
            let tasks = try managedContext.fetch(request) as! [TaskDB]
            print("Data fetched, no issue")
            completion(true, tasks)
        } catch {
            print("Unable to fetch data: ", error.localizedDescription)
            completion(false, nil)
        }
    }
}


/*
 //           _._
 //        .-'   `
 //      __|__
 //     /     \
 //     |()_()|
 //     \{o o}/
 //      =\o/=
 //       ^ ^
 */
