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
        var columnHeights: [CGFloat] = (0..<columns).map { _ in 0 }
        var positions = [CGPoint]()
        var sizes = [CGSize]()
        var columnAssignments = [Int]()

        var canExpand = [Bool]()

        for subview in subviews {
            let shortest = columnHeights.enumerated().min(by: { $0.element < $1.element })!.offset
            let x = CGFloat(shortest) * (columnWidth + spacing)
            let y = columnHeights[shortest]

            let size = subview.sizeThatFits(ProposedViewSize(width: columnWidth, height: nil))

            let actualImgHeight = subview[PrimaryImageFrameHeightKey.self]
            let estimatedImgHeight = subview[EstimatedImageHeightKey.self]

            let height: CGFloat = {
                if let actualImgHeight, let estimatedImgHeight, estimatedImgHeight > 0 {
                    size.height - estimatedImgHeight + actualImgHeight
                } else {
                    size.height
                }
            }()

            positions.append(CGPoint(x: x, y: y))
            sizes.append(CGSize(width: columnWidth, height: height))
            columnAssignments.append(shortest)
            canExpand.append(subview[CanExpandVerticallyKey.self])

            columnHeights[shortest] += height + spacing
        }

        let maxHeight = (columnHeights.max() ?? 0) - (subviews.isEmpty ? 0 : spacing)
        equalizeColumns(positions: &positions, sizes: &sizes, columnAssignments: columnAssignments, columnHeights: columnHeights, maxHeight: maxHeight, canExpand: canExpand)

        return CacheData(positions: positions, sizes: sizes, totalHeight: max(0, maxHeight))
    }

    private func equalizeColumns(positions: inout [CGPoint], sizes: inout [CGSize], columnAssignments: [Int], columnHeights: [CGFloat], maxHeight: CGFloat, canExpand: [Bool]) {
        guard !positions.isEmpty else { return }

        for col in 0..<columns {
            let colHeight = columnHeights[col] - spacing
            let deficit = maxHeight - colHeight

            guard deficit > 1 else { continue } // allow margin for imperfection

            let indices = columnAssignments.enumerated().compactMap { $0.element == col ? $0.offset : nil }
            let expandableIndices = indices.filter { canExpand[$0] }

            guard !expandableIndices.isEmpty else { continue }

            let extraPerItem = deficit / CGFloat(expandableIndices.count)
            for i in expandableIndices {
                sizes[i].height += extraPerItem
            }

            let sortedIndices = indices.sorted { positions[$0].y < positions[$1].y }
            var y: CGFloat = 0
            for i in sortedIndices {
                positions[i].y = y
                y += sizes[i].height + spacing
            }
        }
    }
}
