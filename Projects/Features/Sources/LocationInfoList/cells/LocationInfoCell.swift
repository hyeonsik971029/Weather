//
//  LocationInfoCell.swift
//  Features
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public struct LocationInfoCell: View {
    @Perception.Bindable var store: StoreOf<LocationInfoCellFeature>
    
    public var body: some View {
        WithPerceptionTracking(content: {
            HStack{
                if store.locationInfo.favorites {
                    Text(store.temperature)
                        .font(.title)
                }
                
                Text(store.locationInfo.name)
                
                Spacer()
                
                Image(systemName: store.locationInfo.favorites ? "star.fill": "star")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
        })
    }
}
