//
//  LocationInfoCell.swift
//  Features
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

import Extensions

import ComposableArchitecture

public struct LocationInfoCell: View {
    let store: StoreOf<LocationInfoCellFeature>
    
    public init(store: StoreOf<LocationInfoCellFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            Button(action: {
                store.send(.push(store.locationInfo))
            }) {
                HStack{
                    Text(store.locationInfo.name)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        store.locationInfo.favorites.toggle()
                    }, label: {
                        Image(systemName: store.locationInfo.favorites ? "star.fill": "star")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
}
