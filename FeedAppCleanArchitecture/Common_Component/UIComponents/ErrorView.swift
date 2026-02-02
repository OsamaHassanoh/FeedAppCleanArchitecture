//
//  ErrorView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 01/02/2026.
//

import SwiftUI
struct ErrorView: View {
    let message: String
    let retry: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("Retry", action: retry)
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
