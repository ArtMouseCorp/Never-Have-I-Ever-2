import Foundation

struct Level: Codable, Equatable {
    
    let id: Int
    let name: String
    let description: String
    let image: String
    let taskNames: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, taskNames = "tasks"
    }
    
    public static var all: [Level] = []
    
    public func getTasks() -> [Task] {
        var tasks: [Task] = []
        self.taskNames.forEach { tasks.append(Task(name: $0, level: self)) }
        return tasks
    }
    
    public static func get() {
        
        self.all.removeAll()
        let jsonData = readLocalJSONFile(forName: "levels_\(State.shared.getLanguageCode().rawValue)")!
        do {
            
            let response = try JSONDecoder().decode(Level.Response.self, from: jsonData)
            self.all = response.levels
            
        } catch {
            print("error: \(error)")
        }
    }
    
    
    internal struct Response: Codable {
        let levels: [Level]
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
