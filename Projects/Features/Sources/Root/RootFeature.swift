//
//  RootFeature.swift
//  Features
//
//  Created by 오현식 on 5/2/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Domain

import ComposableArchitecture

@Reducer
public struct RootFeature {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(destination: .locationInfoList(.initalState))
        
        @Presents var destination: Destination.State?
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
    }
    
    public let locationInfoListUseCase: LocationInfoListUseCase
    public init(locationInfoListUseCase: LocationInfoListUseCase) {
        self.locationInfoListUseCase = locationInfoListUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.locationInfoList(.push(let locationInfo)))):
                state.destination = .weatherDetail(.init(locationInfo: locationInfo))
                return .send(.destination(.presented(.weatherDetail(.fetch(locationInfo)))))
            case .destination(.presented(.weatherDetail(.dismiss(let locationInfo)))):
                state.destination = .locationInfoList(.initalState)
                return .send(.destination(.presented(.locationInfoList(.update(locationInfo)))))
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination(locationInfoListUseCase: self.locationInfoListUseCase)
        }
    }
}

extension RootFeature {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case locationInfoList(LocationInfoListFeature.State)
            case weatherDetail(WeatherDetailFeature.State)
        }
        
        public enum Action {
            case locationInfoList(LocationInfoListFeature.Action)
            case weatherDetail(WeatherDetailFeature.Action)
        }
        
        public let locationInfoListUseCase: LocationInfoListUseCase
        public init(locationInfoListUseCase: LocationInfoListUseCase) {
            self.locationInfoListUseCase = locationInfoListUseCase
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.locationInfoList, action: \.locationInfoList) {
                LocationInfoListFeature(locationInfoListUseCase: self.locationInfoListUseCase)
            }
            Scope(state: \.weatherDetail, action: \.weatherDetail) {
                WeatherDetailFeature(locationInfoListUseCase: self.locationInfoListUseCase)
            }
        }
    }
}
