//
//  View+Toolbar.swift
//  Extensions
//
//  Created by 오현식 on 4/27/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

public struct ToolbarItemsContent<L, R>: ToolbarContent where L: View, R: View {
    let leftItems: (() -> L)?
    let rightItems: (() -> R)?
    
    public init(leftItems: (() -> L)? = nil, rightItems: (() -> R)? = nil) {
        self.leftItems = leftItems
        self.rightItems = rightItems
    }
    
    public var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            self.leftItems?()
        }
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            self.rightItems?()
        }
    }
}

public struct ToolbarItemsModifier<L, R>: ViewModifier where L: View, R: View {
    let title: String
    let leftItems: (() -> L)?
    let rightItems: (() -> R)?
    
    public init(title: String, leftItems: (() -> L)? = nil, rightItems: (() -> R)? = nil) {
        self.title = title
        self.leftItems = leftItems
        self.rightItems = rightItems
    }
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemsContent(
                    leftItems: self.leftItems,
                    rightItems: self.rightItems
                )
            }
            .navigationTitle(self.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
    }
}

extension View {
    /// only title
    public func toolbarItems(title: String) -> some View {
        modifier(
            ToolbarItemsModifier(
                title: title,
                leftItems: { EmptyView() },
                rightItems: { EmptyView() }
            )
        )
    }
    /// title + leftItems
    public func toolbarItems<L>(
        title: String,
        leftItems: @escaping (() -> L)
    ) -> some View where L: View {
        modifier(
            ToolbarItemsModifier(
                title: title,
                leftItems: leftItems,
                rightItems: { EmptyView() }
            )
        )
    }
    /// title + rightItems
    public func toolbarItems<R>(
        title: String,
        rightItems: @escaping (() -> R)
    ) -> some View where R: View {
        modifier(
            ToolbarItemsModifier(
                title: title,
                leftItems: { EmptyView() },
                rightItems: rightItems
            )
        )
    }
    /// title + leftItems + rightItems
    public func toolbarItems<L, R>(
        title: String,
        leftItems: @escaping (() -> L),
        rightItems: @escaping (() -> R)
    ) -> some View where L: View, R: View {
        modifier(
            ToolbarItemsModifier(
                title: title,
                leftItems: leftItems,
                rightItems: rightItems
            )
        )
    }
}
