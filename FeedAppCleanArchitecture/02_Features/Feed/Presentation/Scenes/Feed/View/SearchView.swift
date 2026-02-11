//
//  SearchView.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isLoading = false

    var body: some View {
        VStack {
            SearchBar(text: $searchText)

            if isLoading {
                SearchSkeletonView()
            } else if searchText.isEmpty {
                Text("Search for users, posts, or hashtags")
                    .foregroundColor(.secondary)
                    .frame(maxHeight: .infinity)
            } else {
                List {
                    Text("Search results for '\(searchText)'")
                }
            }
        }
        .navigationTitle("Search")
        .onChange(of: searchText) { _ in
            guard !searchText.isEmpty else {
                isLoading = false
                return
            }
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search", text: $text)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
