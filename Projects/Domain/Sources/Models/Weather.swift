//
//  Weather.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

public struct Weather: Codable {
    public let response: Response
}

public struct Response: Codable {
    public let header: Header
    public let body: Body
}

public struct Body: Codable {
    public let dataType: String
    public let items: Items
    public let pageNo: Int
    public let numOfRows: Int
    public let totalCount: Int
}

public struct Items: Codable {
    public let item: [Item]
}

public struct Item: Codable {
    public let baseDate: String
    public let baseTime: String
    public let category: String
    public let fcstDate: String
    public let fcstTime: String
    public let fcstValue: String
    public let nx: Int
    public let ny: Int
}

public struct Header: Codable {
    public let resultCode: String
    public let resultMsg: String
}
