//
//  LocationInfoCellFeature.swift
//  Features
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

import Domain

import ComposableArchitecture

@Reducer
public struct LocationInfoCellFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        public var locationInfo: LocationInfo
        public var temperature: String
        
        public init() {
            self.id = UUID()
            self.locationInfo = LocationInfo()
            self.temperature = ""
        }
    }
    
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}
