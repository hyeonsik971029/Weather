//
//  WeatherRepository.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Combine

public protocol WeatherRepository {
    func weatherByGrid(_ location: LocationInfo) -> AnyPublisher<Weather, Error>
}
