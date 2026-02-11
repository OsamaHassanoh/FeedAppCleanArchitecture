//
//  FeedSectionSelectorView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI

struct FeedSectionSelector: View {
    let sections: [FeedSectionEntity]
    let selectedIndex: Int
    let onSectionSelected: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                    sectionButton(for: section, at: index)
                }
            }
        }
        .frame(height: 50)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Section Button
    
    private func sectionButton(for section: FeedSectionEntity, at index: Int) -> some View {
        let isSelected = selectedIndex == index
        
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                onSectionSelected(index)
            }
        } label: {
            VStack(spacing: 8) {
                Text(section.title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Rectangle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(height: 2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}


