//
//  FeedViewModel.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Combine
import SwiftUI

@MainActor
final class FeedViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var feeds: [FeedSectionEntity] = []
    @Published private(set) var state: FormState = .loading
    @Published private(set) var errorMessage: String?
    
    // MARK: - Private Properties
    private let fetchFeedsUseCase: FetchFeedsUseCaseProtocol
    
    // MARK: - Initialization
    init(fetchFeedsUseCase: FetchFeedsUseCaseProtocol) {
        self.fetchFeedsUseCase = fetchFeedsUseCase
    }
    
    // MARK: - Public Methods
    func loadFeeds() async {
        state = .loading
        errorMessage = nil
        
        do {
            feeds = try await fetchFeedsUseCase.fetchFeeds()
            state = .loaded
        } catch {
            errorMessage = error.localizedDescription
            state = .error
        }
    }
}
