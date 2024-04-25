//
//  LocationInfoListUseCase.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

public protocol LocationInfoListUseCase {
    var locationInfoListRepository: LocationInfoListRepository { get }
    var weatherRepository: WeatherRepository { get }
}
