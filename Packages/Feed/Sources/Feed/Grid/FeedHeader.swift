//
//  FeedHeader.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/7/26.
//

import SwiftUI
import DesignSystem
import ImageService

public enum FeedTab: String, CaseIterable {
    case explore = "Explore"
    case forYou = "For you"
    case trendReport = "Trend report"
}

public struct FeedHeader: View {
    @Binding var selectedTab: FeedTab
    let imageService: ImageService

    public init(selectedTab: Binding<FeedTab>, imageService: ImageService) {
        self._selectedTab = selectedTab
        self.imageService = imageService
    }

    public var body: some View {
        VStack(spacing: 0) {
            Menu {
                Section("Debug Menu") {
                    Button("Clear Cache", role: .destructive) {
                        Task {
                            await imageService.clearCache()
                        }
                    }
                }
            } label: {
                Image(.Custom.logoWhite)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Foreground.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            HStack(alignment: .center, spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(FeedTab.allCases, id: \.self) { tab in
                        tabItem(tab)
                    }
                }

                Spacer()

                Button {
                    // do nothing
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.Foreground.secondary)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.trailing, 10)
            .overlay(alignment: .bottom) {
                Divider()
            }
        }
    }

    private func tabItem(_ tab: FeedTab) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            Text(tab.rawValue)
                .customFont(.Label.small)
                .foregroundStyle(isSelected ? Color.Foreground.primary : Color.Foreground.tertiary)
                .frame(width: 95, height: 40)
                .overlay(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                        .fill(isSelected ? Color.Foreground.primary : .clear)
                        .frame(height: 2)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FontManager.registerFonts()

    return FeedHeader(selectedTab: .constant(.explore), imageService: ImageService())
}
