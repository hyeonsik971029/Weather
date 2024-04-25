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

import ComposableArchitecture


public struct LocationListView: View {
    let store: StoreOf<LocationInfoListFeature>
    
    @State private var searchText: String
    
    public init(store: StoreOf<LocationInfoListFeature>, searchText: String = "") {
        self.store = store
        self.searchText = searchText
    }
    
    public var body: some View {
        WithPerceptionTracking(content: {
            NavigationView {
                List(store.locationInfoList, id: \.name) { location in
                    NavigationLink {
                        self.detailView(location)
                    } label: {
                        Text("\(location.name)")
                    }
                }
                .navigationTitle("지역 명")
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "지역 명"
                )
            }
            .onAppear {
                store.send(.refresh)
            }
            .onChange(of: searchText) { searchText in
                store.send(.searchTerm(searchText))
            }
        })
    }
    
    func detailView(_ location: LocationInfo) -> some View {
        
        var isFavorites = location.favorites
        
        var body: some View {
            WithPerceptionTracking(content: {
                HStack {
                    // 현재 기온, 최저/최고 온도
                    VStack {
                        Text(store.temperature.curr)
                        Text("\(location.name)")
                        Text("최저: \(store.temperature.min) 최대: \(store.temperature.max)")
                    }
                    .onAppear {
                        store.send(.loadWeather(location))
                    }
                    
                    // 즐겨찾기
                    Button(action: {
                        isFavorites.toggle()
                        store.send(.updateFavorites(isFavorites))
                    }, label: {
                        Image(systemName: store.isFavorites ? "star.fill": "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                            .onAppear {
                                store.send(.updateFavorites(isFavorites))
                            }
                            .onDisappear {
                                searchText = ""
                                store.send(.dismiss(location.name, isFavorites))
                            }
                    })
                }
            })
        }
        
        return body
    }
}

