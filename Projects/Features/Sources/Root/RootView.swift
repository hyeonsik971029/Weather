//
//  File.swift
//  Features
//
//  Created by 오현식 on 5/2/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public struct RootView: View {
    @Perception.Bindable var store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            NavigationView {
                NavigationLink(
                    item: $store.scope(state: \.destination, action: \.destination),
                    destination: { store in
                        switch store.state {
                        case .locationInfoList:
                            if let store = store.scope(
                                state: \.locationInfoList,
                                action: \.locationInfoList
                            ) {
                                LocationListView(store: store)
                            }
                        case .weatherDetail:
                            if let store = store.scope(
                                state: \.weatherDetail,
                                action: \.weatherDetail
                            ) {
                                WeatherDetailView(store: store)
                            }
                        }
                    }, label: {}
                )
            }
        }
    }
}
