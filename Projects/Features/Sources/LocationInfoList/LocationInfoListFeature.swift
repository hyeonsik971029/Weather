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
        public static let initalState = State(locationInfoCellList: [])
        
        public var locationInfoCellList: IdentifiedArrayOf<LocationInfoCellFeature.State>
    }
    
    public enum Action {
        case refresh
        case searchTerm(String)
        case locationInfoCellList([LocationInfo])
        case locationInfoCell(IdentifiedActionOf<LocationInfoCellFeature>)
        case update(LocationInfo)
        case push(LocationInfo)
    }
    
    public let locationInfoListUseCase: LocationInfoListUseCase
    public init(locationInfoListUseCase: LocationInfoListUseCase) {
        self.locationInfoListUseCase = locationInfoListUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refresh:
                let locationInfoList = locationInfoListUseCase
                    .locationInfoListRepository
                    .locationInfoList()
                let isFavorites = locationInfoList.filter { $0.favorites }
                return .send(.locationInfoCellList(isFavorites.isEmpty ? locationInfoList: isFavorites))
            case .searchTerm(let text):
                if text.isEmpty {
                    return .send(.refresh)
                } else {
                    let filtered = locationInfoListUseCase
                        .locationInfoListRepository
                        .locationInfoList()
                    return .send(.locationInfoCellList(filtered.filter { $0.name.contains(text) }))
                }
            case .locationInfoCellList(let locationInfoList):
                let locationInfoCellList = locationInfoList.map {
                    LocationInfoCellFeature.State(locationInfo: $0)
                }
                state.locationInfoCellList = .init(uniqueElements: locationInfoCellList)
                return .none
            case .update(let locationInfo):
                locationInfoListUseCase.locationInfoListRepository.update(locationInfo)
                return .send(.refresh)
            case .locationInfoCell(.element(id: _, action: .update(let locationInfo))):
                return .send(.update(locationInfo))
            case .locationInfoCell(.element(id: _, action: .push(let locationInfo))):
                return .send(.push(locationInfo))
            case .locationInfoCell:
                return .none
            case .push:
                return .none
            }
        }
        .forEach(\.locationInfoCellList, action: \.locationInfoCell) {
            LocationInfoCellFeature()
        }
    }
}
