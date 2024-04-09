//
//  LocationsView.swift
//  weather-grid
//
//  Created by 오현식 on 4/9/24.
//  Copyright © 2024 weather-ios. All rights reserved.
//

import SwiftUI

import Combine
import ComposableArchitecture


struct LocationsView: View {
    typealias Temperature = (tmp: String, tmn: String, tmx: String)
    
    let store: StoreOf<LocationsFeature>
    
    @State private var searchText = ""
    
    var body: some View {
        WithPerceptionTracking(content: {
            NavigationView {
                List(store.locations, id: \.name) { location in
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
    
    @State private var isFavorites = false
    
    func detailView(_ location: Location) -> some View {
        
        var body: some View {
            WithPerceptionTracking(content: {
                HStack {
                    // 현재 기온, 최저/최고 온도
                    VStack {
                        Text(store.temperature.tmp)
                        Text("\(location.name)")
                        Text("최저: \(store.temperature.tmn) 최대: \(store.temperature.tmx)")
                    }
                    .onAppear {
                        self.store.send(.loadWeather(location))
                    }
                    
                    // 즐겨찾기
                    Button(action: {
                        isFavorites.toggle()
                        store.send(.updateFavorites(isFavorites))
                    }, label: {
                        Image(isFavorites ? "icon_star_fill": "icon_star_empty")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .onAppear {
                                isFavorites = location.favorites
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
