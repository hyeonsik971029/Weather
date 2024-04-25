//
//  LocationInfoListRepository.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

public protocol LocationInfoListRepository {
    func locationInfoListByCSV() -> [LocationInfo]
    func locationInfoListBySimpleDefaults() -> [LocationInfo]
    func locationInfoList() -> [LocationInfo]
    
    func updateFavorites(name: String, favorites: Bool)
}
