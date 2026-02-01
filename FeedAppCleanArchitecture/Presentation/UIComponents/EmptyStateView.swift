//
//  EmptyStateView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    @ObservedObject var themeManager = ThemeManager()
    let title: String
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            Text(title)
                .font(themeManager.selectedTheme.fonts.titleTextFont)
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
