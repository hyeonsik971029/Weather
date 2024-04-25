import Foundation

public class SimpleDefaults {
    
    public static let shared = SimpleDefaults()
    
    public func save<T: Codable>(_ key: String, array: [T]) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        do {
            let encode = try JSONEncoder().encode(array)
            UserDefaults.standard.set(encode, forKey: "\(T.self).\(key)")
        } catch {
            print("Failed to encode locations: \(error)")
        }
    }
    
    public func load<T: Codable>(_ key: String) -> [T] {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard let encode = UserDefaults.standard.data(forKey: "\(T.self).\(key)") else { return [] }
        do {
            let locations = try JSONDecoder().decode([T].self, from: encode)
            return locations
        } catch {
            print("Failed to decode locations: \(error)")
            return []
        }
    }
    
    public func isEmpty<T: Codable>(_ key: String, type: T.Type) -> Bool {
        let items: [T] = self.load(key)
        return items.isEmpty
    }
}
