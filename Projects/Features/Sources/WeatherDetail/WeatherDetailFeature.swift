//
//  WeatherDetailFeature.swift
//  Features
//
//  Created by 오현식 on 4/25/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Combine
import Foundation

import Domain

import ComposableArchitecture

@Reducer
public struct WeatherDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public static let initalState = State(locationInfo: .init())
        
        public var locationInfo: LocationInfo
        public var temperature: Temperature = .init()
        
        public init(locationInfo: LocationInfo) {
            self.locationInfo = locationInfo
        }
    }
    
    public enum Action {
        case fetch(LocationInfo)
        case temperature(Temperature)
        case update(Bool)
        case dismiss(LocationInfo)
        case errorMessage
    }
    
    public let locationInfoListUseCase: LocationInfoListUseCase
    public init(locationInfoListUseCase: LocationInfoListUseCase) {
        self.locationInfoListUseCase = locationInfoListUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetch(let locationInfo):
                return self.weatherByGrid(locationInfo)
            case .temperature(let temperature):
                state.temperature = temperature
                return .none
            case .update(let favorites):
                state.locationInfo.favorites = favorites
                return .none
            case .dismiss:
                return .none
            case .errorMessage:
                return .none
            }
        }
    }
    
    func weatherByGrid(_ locationInfo: LocationInfo) -> Effect<WeatherDetailFeature.Action> {
        return Effect.publisher {
            self.locationInfoListUseCase.weatherRepository.weatherByGrid(locationInfo)
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
                    
                    return .temperature(temperature)
                }
                .receive(on: DispatchQueue.main)
                .catch { _ in Just(.errorMessage) }
        }
    }
}
