//
//  LocationInfoListView.swift
//  Features
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Combine
import SwiftUI

import Domain
import Extensions

import ComposableArchitecture


public struct LocationListView: View {
    @Perception.Bindable var store: StoreOf<LocationInfoListFeature>
    
    @State private var searchText: String
    
    public init(store: StoreOf<LocationInfoListFeature>, searchText: String = "") {
        self.store = store
        self.searchText = searchText
    }
    
    public var body: some View {
        WithPerceptionTracking {
            List {
                ForEach(
                    store.scope(
                        state: \.locationInfoCellList,
                        action: \.locationInfoCell
                    )
                ) { store in
                    LocationInfoCell(store: store)
                }
            }
            .toolbarItems(title: "지역 명")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "지역 명"
            )
            .onAppear {
                store.send(.refresh)
            }
            .onChange(of: searchText) { searchText in
                store.send(.searchTerm(searchText))
            }
        }
    }
}
