//
//  LocationInfoListUseCaseImpl.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

public class LocationInfoListUseCaseImpl: LocationInfoListUseCase {
    public var locationInfoListRepository: LocationInfoListRepository
    public var weatherRepository: WeatherRepository
    
    public init(
        locationInfoListRepository: LocationInfoListRepository,
        weatherRepository: WeatherRepository
    ) {
        self.locationInfoListRepository = locationInfoListRepository
        self.weatherRepository = weatherRepository
    }
}
