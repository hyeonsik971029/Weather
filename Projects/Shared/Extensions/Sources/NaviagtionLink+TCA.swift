//
//  NaviagtionLink.swift
//  Extensions
//
//  Created by 오현식 on 5/1/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

@available(iOS, introduced: 13, deprecated: 16)
@available(macOS, introduced: 10.15, deprecated: 13)
@available(tvOS, introduced: 13, deprecated: 16)
@available(watchOS, introduced: 6, deprecated: 9)
extension NavigationLink {
    public init<D, C: View>(
        item: Binding<D?>,
        @ViewBuilder destination: (D) -> C,
        @ViewBuilder label: () -> Label
    ) where Destination == C? {
        self.init(
            destination: item.wrappedValue.map(destination),
            isActive: Binding(
                get: { item.wrappedValue != nil },
                set: { isActive, transaction in
                    if !isActive {
                        item.transaction(transaction).wrappedValue = nil
                    }
                }
            ),
            label: label
        )
    }
}
