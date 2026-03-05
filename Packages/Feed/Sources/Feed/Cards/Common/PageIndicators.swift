//
//  PageIndicators.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI

struct PageIndicators: View {
    let totalPages: Int
    /// 0-indexed
    let currentPage: Int

    var body: some View {
        if totalPages <= 3 {
            HStack {
                ForEach(0..<totalPages, id: \.self) { page in
                    Group {
                        if page == currentPage {
                            Circle()
                                .foregroundStyle(Color.Foreground.onColor)
                        } else {
                            Circle()
                                .foregroundStyle(Color.Overlay.dark500)
                        }
                    }
                    .id(page)
                    .frame(width: 6, height: 6)
                }
            }
        } else {
            if currentPage >= 2 {
                
            } else {

            }
        }
    }
}

#Preview {
    PageIndicators(totalPages: 3, currentPage: 1)
}
