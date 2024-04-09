//
//  Location.swift
//  Weather
//
//  Created by 오현식 on 3/23/24.
//

import Foundation

struct Location: Codable, Equatable {
    /// 지역 이름
    let name: String
    /// Grid X
    let x: String
    /// Grid Y
    let y: String
    /// 즐겨찾기
    var favorites: Bool
}
