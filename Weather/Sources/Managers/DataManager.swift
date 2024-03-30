//
//  DataManager.swift
//  Weather
//
//  Created by 오현식 on 3/28/24.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    // Locations
    func saveLocations(_ key: String, locations: [Location]) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        do {
            let encode = try JSONEncoder().encode(locations)
            UserDefaults.standard.set(encode, forKey: key)
        } catch {
            print("Failed to encode locations: \(error)")
        }
    }
    
    func loadLocations(_ key: String) -> [Location] {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard let encode = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            let locations = try JSONDecoder().decode([Location].self, from: encode)
            return locations
        } catch {
            print("Failed to decode locations: \(error)")
            return []
        }
    }
    
    func updateFavorites(_ key: String, name: String, favorites: Bool) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard let encode = UserDefaults.standard.data(forKey: key) else { return }
        do {
            var locations = try JSONDecoder().decode([Location].self, from: encode)
            if let index = locations.firstIndex(where: { $0.name == name }) {
                locations[index].favorites = favorites
                self.saveLocations(key, locations: locations)
            }
        } catch {
            print("Failed to decode locations: \(error)")
        }
    }
    
    func isLocationsEmpty(_ key: String) -> Bool {
        return self.loadLocations(key).isEmpty
    }
}
