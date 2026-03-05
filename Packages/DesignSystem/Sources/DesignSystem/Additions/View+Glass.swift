//
//  View+Glass.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func phiaGlass() -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.regular.interactive())
        } else {
            self
                .phiaGlassFallback()
        }
    }

    fileprivate func phiaGlassFallback() -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}
