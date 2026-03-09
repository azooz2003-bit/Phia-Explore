//
//  MasonryLayout.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI

public struct MasonryLayout: Layout {
    public struct CacheData {
        var positions: [CGPoint] = []
        var sizes: [CGSize] = []
        var totalHeight: CGFloat = 0
    }

    public let columns: Int
    public let spacing: CGFloat

    public init(columns: Int = 2, spacing: CGFloat = 6) {
        self.columns = columns
        self.spacing = spacing
    }

    public func makeCache(subviews: Subviews) -> CacheData {
        CacheData()
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
        cache = computeLayout(proposal: proposal, subviews: subviews)
        return CGSize(width: proposal.width ?? 0, height: cache.totalHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
        for (index, subview) in subviews.enumerated() {
            guard index < cache.positions.count else { break }
            
            let x = bounds.minX + cache.positions[index].x
            let y = bounds.minY + cache.positions[index].y

            subview.place(at: CGPoint(x: x,y: y), anchor: .topLeading, proposal: ProposedViewSize(cache.sizes[index]))
        }
    }

    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> CacheData {
        let totalWidth = proposal.width ?? 0
        let columnWidth = (totalWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
        var columnHeights: [CGFloat] = Array(repeating: 0, count: columns)
        var positions = [CGPoint]()
        var sizes = [CGSize]()

        for subview in subviews {
            let shortest = columnHeights.enumerated().min(by: { $0.element < $1.element })!.offset
            let x = CGFloat(shortest) * (columnWidth + spacing)
            let y = columnHeights[shortest]

            let size = subview.sizeThatFits(ProposedViewSize(width: columnWidth, height: nil))

            positions.append(CGPoint(x: x, y: y))
            sizes.append(CGSize(width: columnWidth, height: size.height))

            columnHeights[shortest] += size.height + spacing
        }

        let maxHeight = (columnHeights.max() ?? 0) - (subviews.isEmpty ? 0 : spacing)
        return CacheData(positions: positions, sizes: sizes, totalHeight: max(0, maxHeight))
    }
}
