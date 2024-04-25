//
//  LoctionInfo.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

public struct LocationInfo: Codable, Equatable {
    /// name
    public let name: String
    /// Grid X
    public let x: String
    /// Grid Y
    public let y: String
    /// Favorites
    public var favorites: Bool
    /// initalizations
    public init() {
        self.name = ""
        self.x = ""
        self.y = ""
        self.favorites = false
    }
    public init(name: String, x: String, y: String, favorites: Bool) {
        self.name = name
        self.x = x
        self.y = y
        self.favorites = favorites
    }
}
