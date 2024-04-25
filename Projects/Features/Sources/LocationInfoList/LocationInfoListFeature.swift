//
//  LocationInfoListFeature.swift
//  Features
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Combine
import Foundation

import Domain

import ComposableArchitecture


@Reducer
public struct LocationInfoListFeature {
    @ObservableState
    public struct State: Equatable {
        var locationInfoList: [LocationInfo] = []
        var temperature: Temperature = .init()
        var isFavorites: Bool = false
        
        public init() {}
    }
    
    public enum Action {
        case refresh
        case searchTerm(String)
        case locationInfoList([LocationInfo])
        case loadWeather(LocationInfo)
        case weather(Temperature)
        case updateFavorites(Bool)
        case dismiss(String, Bool)
        case errorMessage
    }
    
    private enum CancelIdentifier {
        case debounced
    }
    
    public let locationInfoListUseCase: LocationInfoListUseCase
    public init(locationInfoListUseCase: LocationInfoListUseCase) {
        self.locationInfoListUseCase = locationInfoListUseCase
    }
    
    @Dependency(\.mainQueue) var mainQueue
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refresh:
                let locationInfoList = locationInfoListUseCase
                    .locationInfoListRepository
                    .locationInfoList()
                let isFavorites = locationInfoList.filter { $0.favorites }
                return .send(.locationInfoList(isFavorites.isEmpty ? locationInfoList: isFavorites))
            case .searchTerm(let text):
                if text.isEmpty {
                    return .send(.refresh)
                } else {
                    let filtered = locationInfoListUseCase
                        .locationInfoListRepository
                        .locationInfoList()
                    return .send(.locationInfoList(filtered.filter { $0.name.contains(text) }))
                        .debounce(id: CancelIdentifier.debounced, for: 0.2, scheduler: mainQueue)
                }
            case .locationInfoList(let locationInfoList):
                state.locationInfoList = locationInfoList
                return .none
            case .loadWeather(let locationInfo):
                return self.weatherByLocationInfo(locationInfo)
            case .weather(let temperature):
                state.temperature = temperature
                return .none
            case .updateFavorites(let isFavorites):
                state.isFavorites = isFavorites
                return .none
            case .dismiss(let name, let favorites):
                locationInfoListUseCase
                    .locationInfoListRepository
                    .updateFavorites(name: name, favorites: favorites)
                return .concatenate(
                    .send(.refresh),
                    .send(.updateFavorites(false))
                )
            case .errorMessage:
                return .none
            }
        }
    }
    
    func weatherByLocationInfo(_ locationInfo: LocationInfo) -> Effect<LocationInfoListFeature.Action> {
        return Effect.publisher {
            locationInfoListUseCase.weatherRepository.weatherByGrid(locationInfo)
                .map { weather in
                    var temperature = Temperature()
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
                                temperature.curr = $0.fcstValue
                            case "TMN":
                                temperature.min = $0.fcstValue
                            case "TMX":
                                temperature.max = $0.fcstValue
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


