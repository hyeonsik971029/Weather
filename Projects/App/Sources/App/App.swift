import SwiftUI

import Features
import Data
import Domain

@main
struct _App: App {
    static let locationInfoListRepository = LocationInfoListRepositoryImpl()
    static let weatherRepository = WeatherRepositoryImpl()
    static let locationInfoListUseCase = LocationInfoListUseCaseImpl(
        locationInfoListRepository: locationInfoListRepository,
        weatherRepository: weatherRepository
    )
    
    var body: some Scene {
        WindowGroup {
            LocationListView(
                store: .init(
                    initialState: LocationInfoListFeature.State()
                ) {
                    LocationInfoListFeature(locationInfoListUseCase: _App.locationInfoListUseCase)
                }
            )
        }
    }
}
