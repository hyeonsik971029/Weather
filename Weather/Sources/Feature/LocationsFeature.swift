//
//  LocationsFeature.swift
//  weather-grid
//
//  Created by 오현식 on 4/2/24.
//  Copyright © 2024 weather-ios. All rights reserved.
//

import Foundation

import Combine
import ComposableArchitecture


@Reducer
struct LocationsFeature {
    typealias Temperature = (tmp: String, tmn: String, tmx: String)
    
    @ObservableState
    struct State: Equatable {
        static func == (lhs: LocationsFeature.State, rhs: LocationsFeature.State) -> Bool {
            return lhs.locations == rhs.locations && lhs.temperature == rhs.temperature
        }
        
        var locations: [Location] = []
        var temperature: Temperature = ("", "", "")
        var isFavorites = false
    }
    
    enum Action {
        case refresh
        case searchTerm(String)
        case locations([Location])
        case loadWeather(Location)
        case weather(Temperature)
        case updateFavorites(Bool)
        case dismiss(String, Bool)
        case errorMessage
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refresh:
                var locations = [Location]()
                if DataManager.shared.isLocationsEmpty("Locations") {
                    locations = self.locationsByCSV()
                    DataManager.shared.saveLocations("Locations", locations: locations)
                } else {
                    locations = DataManager.shared.loadLocations("Locations")
                }
                let isFavorites = locations.filter { $0.favorites }
                return .send(.locations(isFavorites.isEmpty ? locations: isFavorites))
            case .searchTerm(let text):
                if text.isEmpty {
                    return .send(.refresh)
                } else {
                    let filtered = DataManager.shared.loadLocations("Locations").filter {
                        $0.name.contains(text)
                    }
                    
                    return .send(.locations(filtered))
                }
            case .locations(let locations):
                state.locations = locations
                return .none
            case .loadWeather(let location):
                return self.weatherByLocations(location)
            case .weather(let temperature):
                state.temperature = temperature
                return .none
            case .updateFavorites(let isFavorites):
                state.isFavorites = isFavorites
                return .none
            case .dismiss(let name, let favorites):
                DataManager.shared.updateFavorites(
                    "Locations",
                    name: name,
                    favorites: favorites
                )
                return .concatenate(
                    .send(.refresh),
                    .send(.updateFavorites(false))
                )
            case .errorMessage:
                return .none
            }
        }
    }
    
    func locationsByCSV() -> [Location] {
        var locationsArr = [Location]()
        if let path = Bundle.main.path(forResource: "Locations_Grid", ofType: "csv") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                if let dataEncoded = String(data: data, encoding: .utf8) {
                    let dataArr = dataEncoded
                        .components(separatedBy: "\r\n")
                        .map { $0.components(separatedBy: ",") }
                    for data in dataArr {
                        if data.count != 3 { continue }
                        locationsArr.append(Location(
                            name: data[0],
                            x: data[1],
                            y: data[2],
                            favorites: false
                        ))
                    }
                }
            } catch {
                print("Error reading CSV file: \(error.localizedDescription)")
            }
        } else {
            print("CSV file not found.")
        }
        
        return locationsArr
    }
    
    func weatherByLocations(_ location: Location) -> Effect<LocationsFeature.Action> {
        return Effect.publisher {
            NetworkManager.shared.weatherByLocations(location)
                .map { weather in
                    var temperature = Temperature("", "", "")
                    let items = weather.response.body.items.item
                    var dateToString: String? {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMdd"
                        let dateToString = formatter.string(from: Date())
                        return dateToString
                    }
                    items.forEach {
                        if $0.baseDate == dateToString {
                            switch $0.category {
                            case "TMP":
                                temperature.tmp = $0.fcstValue
                            case "TMN":
                                temperature.tmn = $0.fcstValue
                            case "TMX":
                                temperature.tmx = $0.fcstValue
                            default:
                                break
                            }
                        }
                    }
                    
                    return .weather(temperature)
                }
                .receive(on: DispatchQueue.main)
                .catch { _ in Just(.errorMessage) }
        }
    }
}
