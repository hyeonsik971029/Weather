//
//  Weather.swift
//  Weather
//
//  Created by 오현식 on 3/23/24.
//

import Foundation


struct Weather: Codable {
    let response: Response
}

struct Response: Codable {
    let header: Header
    let body: Body
}

struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct Items: Codable {
    let item: [Item]
}

struct Item: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}
