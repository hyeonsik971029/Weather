//
//  Temperature.swift
//  Domain
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Foundation

public struct Temperature: Equatable {
    /// current
    public var curr: String
    /// lowest
    public var min: String
    /// highest
    public var max: String
}

extension Temperature {
    /// initalization
    public init() {
        self.curr = ""
        self.min = ""
        self.max = ""
    }
}
