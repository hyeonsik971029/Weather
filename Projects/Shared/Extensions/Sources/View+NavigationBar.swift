//
//  View+NavigationBar.swift
//  Extensions
//
//  Created by 오현식 on 4/27/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import SwiftUI

public struct NavigationBarItemsContent<R>: ViewModifier where R: View {
    let title: String
    let isBackButtonHidden: Bool
    let rightItems: (() -> R)?
    
    init(
        title: String,
        isBackButtonHidden: Bool,
        rightItems: (() -> R)? = nil
    ) {
        self.title = title
        self.isBackButtonHidden = isBackButtonHidden
        self.rightItems = rightItems
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    /// Back Button
                    if self.isBackButtonHidden == false {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    
                    self.rightItems?()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    
                    Text(self.title)
                        .font(.system(size: 24))
                        .bold()
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .background(Color(.white).ignoresSafeArea(.all, edges: .top))
            
            content
            
            Spacer()
        }
    }
}

extension View {
    public func navigationBarItems(
        title: String,
        isBackButtonHidden: Bool = true
    ) -> some View {
        modifier(
            NavigationBarItemsContent(
                title: title,
                isBackButtonHidden: isBackButtonHidden,
                rightItems: {
                    EmptyView()
                }
            )
        )
    }
    
    public func navigationBarItems<R>(
        title: String,
        isBackButtonHidden: Bool = true,
        rightItems: @escaping (() -> R)
    ) -> some View where R: View {
        modifier(
            NavigationBarItemsContent(
                title: title,
                isBackButtonHidden: isBackButtonHidden,
                rightItems: rightItems
            )
        )
    }
}
