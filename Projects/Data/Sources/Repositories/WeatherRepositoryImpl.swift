//
//  WeatherRepositoryImpl.swift
//  Data
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Combine
import Foundation

import Domain

public class WeatherRepositoryImpl: WeatherRepository {
    public init() {}
    
    public func weatherByGrid(_ location: LocationInfo) -> AnyPublisher<Weather, Error> {
        return NetworkManager.shared.weatherByGrid(location)
    }
}
