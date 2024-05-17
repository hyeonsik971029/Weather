//
//  View.swift
//  Extensions
//
//  Created by 오현식 on 4/27/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

extension View {
    /// 뷰 tap 이벤트 발생하기 위해
    public func onTapGestureForced(
        count: Int = 1,
        perform action: @escaping () -> Void
    ) -> some View {
        self.contentShape(Rectangle())
            .onTapGesture(count:count, perform:action)
    }
}
