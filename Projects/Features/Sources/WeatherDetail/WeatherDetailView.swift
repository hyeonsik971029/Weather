//
//  WeatherDetailView.swift
//  Features
//
//  Created by 오현식 on 4/27/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

import Extensions

import ComposableArchitecture

public struct WeatherDetailView: View {
    var store: StoreOf<WeatherDetailFeature>
    
    public init(store: StoreOf<WeatherDetailFeature>) {
        self.store = store
    }
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        var favorites = store.locationInfo.favorites
        
        WithPerceptionTracking {
            // 현재 기온, 최저/최고 온도
            VStack {
                Text("\(store.temperature.curr)°")
                    .font(.system(size: 64))
                
                Text("\(store.locationInfo.name)")
                Text("최저: \(store.temperature.min) 최대: \(store.temperature.max)")
                
                Spacer()
            }
            .toolbarItems(
                title: "",
                leftItems: {
                    /// 뒤로가기
                    Button(action: {
                        store.send(.dismiss(store.locationInfo))
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                },
                rightItems: {
                    /// 즐겨찾기
                    Button(action: {
                        favorites.toggle()
                        store.send(.update(favorites))
                    }, label: {
                        Image(systemName: store.locationInfo.favorites ? "star.fill": "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    })
                }
            )
        }
    }
}
