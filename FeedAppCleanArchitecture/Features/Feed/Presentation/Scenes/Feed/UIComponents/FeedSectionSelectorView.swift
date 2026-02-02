//
//  FeedSectionSelectorView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI

struct FeedSectionSelectorView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let feedSectionEntity: [FeedSectionEntity]
    let selectedSectionID: String
    let onSelect: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(feedSectionEntity) { section in
                    Button {
                        withAnimation {
                            onSelect(section.id)
                        }
                    } label: {
                        Text(section.title)
                            .font(.subheadline.bold())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(
                                        selectedSectionID == section.id
                                            ? themeManager.selectedTheme.colors.primaryThemeColor
                                            : themeManager.selectedTheme.colors.secondaryThemeColor // Color.gray.opacity(0.2)
                                    )
                            )
                            .foregroundColor(
                                selectedSectionID == section.id
                                    ? .white
                                    : .primary
                            )
                    }
                }
            }
            .padding()
        }
    }
}
