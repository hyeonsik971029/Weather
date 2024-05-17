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
        public var id: UUID
        public var locationInfo: LocationInfo
        
        public init(locationInfo: LocationInfo) {
            self.id = UUID()
            self.locationInfo = locationInfo
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case update(LocationInfo)
        case push(LocationInfo)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.locationInfo) { old, new in
                Reduce { state, action in
                        .run { send in
                            await send(.update(new))
                        }
                }
            }
    }
}
