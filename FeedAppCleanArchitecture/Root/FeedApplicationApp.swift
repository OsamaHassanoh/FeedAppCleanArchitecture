//
//  FeedApplicationApp.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI
import Kingfisher

@main
struct FeedApplicationApp: App {
    @Environment(\.scenePhase) private var scenePhase // Observe scene phase changes
    @StateObject private var themeManager = ThemeManager()
    
    init() {
           configureImageCache()
       }
    
    var body: some Scene {
        WindowGroup {
            FeedView()
                .environmentObject(themeManager)
        }
    }
    
    private func configureImageCache() {
            // Configure memory cache (100 MB)
            KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
            
            // Configure disk cache (500 MB)
            KingfisherManager.shared.cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024
            
            // Set cache expiration (7 days)
            KingfisherManager.shared.cache.diskStorage.config.expiration = .days(7)
            
            // Clean expired cache on app launch
            KingfisherManager.shared.cache.cleanExpiredDiskCache()
        }
}
