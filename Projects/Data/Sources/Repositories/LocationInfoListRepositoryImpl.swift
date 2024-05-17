//
//  LocationInfoListRepositoryImpl.swift
//  Data
//
//  Created by 오현식 on 4/24/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

import Domain
import Utilities

public class LocationInfoListRepositoryImpl: LocationInfoListRepository {
    public init() {}
    
    public func locationInfoListByCSV() -> [LocationInfo] {
        var locationsArr = [LocationInfo]()
        
        if let path = Bundle(identifier: "hyeonsik.Data")?.path(forResource: "Locations_Grid", ofType: "csv") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                if let dataEncoded = String(data: data, encoding: .utf8) {
                    let dataArr = dataEncoded
                        .components(separatedBy: "\r\n")
                        .map { $0.components(separatedBy: ",") }
                    for data in dataArr {
                        if data.count != 3 { continue }
                        locationsArr.append(LocationInfo(
                            name: data[0],
                            x: data[1],
                            y: data[2],
                            favorites: false
                        ))
                    }
                    
                    SimpleDefaults.shared.save("Locations", array: locationsArr)
                }
            } catch {
                print("Error reading CSV file: \(error.localizedDescription)")
            }
        } else {
            print("CSV file not found.")
        }
        
        return locationsArr
    }
    
    public func locationInfoListBySimpleDefaults() -> [LocationInfo] {
        return SimpleDefaults.shared.isEmpty("Locations", type: LocationInfo.self) ? []: SimpleDefaults.shared.load("Locations")
    }
    
    public func locationInfoList() -> [LocationInfo] {
        let locationList = self.locationInfoListBySimpleDefaults()
        return locationList.isEmpty ? self.locationInfoListByCSV(): locationList
    }
    
    public func update(_ locationInfo: LocationInfo) {
        var new: [LocationInfo] = SimpleDefaults.shared.load("Locations")
        if let index = new.firstIndex(where: { $0.name == locationInfo.name }) {
            new[index] = locationInfo
        }
        SimpleDefaults.shared.save("Locations", array: new)
    }
}
