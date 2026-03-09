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

    private let maxVisible = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(visibleIndices, id: \.self) { page in
                Circle()
                    .foregroundStyle(page == currentPage ? Color.Foreground.onColor : Color.Overlay.dark500)
                    .frame(width: dotSize(for: page), height: dotSize(for: page))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: currentPage)
    }

    private var visibleIndices: [Int] {
        guard totalPages > maxVisible else {
            return Array(0..<totalPages)
        }

        let windowStart: Int
        if currentPage <= 2 {
            windowStart = 0
        } else if currentPage >= totalPages - 3 {
            windowStart = totalPages - maxVisible
        } else {
            windowStart = currentPage - 2
        }

        let windowEnd = (windowStart + maxVisible)
        return Array(windowStart..<windowEnd)
    }

    private func dotSize(for page: Int) -> CGFloat {
        let distance = abs(page - currentPage)

        switch distance {
        case 0: return 6
        case 1: return 5
        case 2: return 4
        default: return 3
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PageIndicators(totalPages: 3, currentPage: 1)
        PageIndicators(totalPages: 4, currentPage: 1)
        PageIndicators(totalPages: 7, currentPage: 0)
        PageIndicators(totalPages: 7, currentPage: 3)
        PageIndicators(totalPages: 7, currentPage: 6)
        PageIndicators(totalPages: 10, currentPage: 5)
    }
    .padding()
    .background(.black)
}
