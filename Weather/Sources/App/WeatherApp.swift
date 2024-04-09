import SwiftUI

import ComposableArchitecture

@main
struct WeatherApp: App {
    static let store = Store(initialState: LocationsFeature.State()) {
        LocationsFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            LocationsView(store: WeatherApp.store)
        }
    }
}
