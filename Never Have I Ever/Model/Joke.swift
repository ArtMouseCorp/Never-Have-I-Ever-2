import Foundation

struct Joke: Codable {
    
    let id: Int
    let title: String
    let image: String
    let text: String
    
    public static var all: [Joke] = []
    
    public static let `default` = Joke(id: 0, title: "Title", image: "image", text: "Text")
    
    public static func getAll() {
        
        self.all.removeAll()
        guard let jsonData = readLocalJSONFile(forName: "jokes_\(State.shared.getLanguageCode().rawValue)") else { return }
        
        do {
            let decodedData = try JSONDecoder().decode(Joke.Response.self, from: jsonData)
            self.all = decodedData.jokes
        } catch {
            print("Error: ", error)
        }
    }
    
    internal struct Response: Codable {
        let jokes: [Joke]
    }
    
}
