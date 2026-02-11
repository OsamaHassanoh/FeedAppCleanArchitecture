//
//  FeedApplicationApp.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI
import Kingfisher

@main
struct FeedAppCleanArchitectureApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var router = AppDIContainer.shared.router

    init() {
        configureImageCache()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                FeedView(viewModel: AppDIContainer.shared.feedContainer.makeFeedViewModel())
                    .navigationDestination(for: AppRoute.self) { route in
                        RouterView(route: route)
                    }
            }
            .environmentObject(themeManager)
            .environmentObject(router)
            .sheet(item: $router.presentedSheet) { route in
                NavigationStack {
                    RouterView(route: route)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Done") {
                                    router.dismissSheet()
                                }
                            }
                        }
                }
                .environmentObject(router)
            }
            .fullScreenCover(item: $router.presentedFullScreen) { route in
                RouterView(route: route)
                    .environmentObject(router)
            }
            .onOpenURL { url in
                DeepLinkHandler.handle(url, router: router)
            }
        }
    }

    private func configureImageCache() {
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        KingfisherManager.shared.cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024
        KingfisherManager.shared.cache.diskStorage.config.expiration = .days(7)
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}
