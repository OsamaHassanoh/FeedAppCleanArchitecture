//
//  AppRouter.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//
import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {
    // MARK: - Published Properties
    @Published var path = NavigationPath()
    @Published var presentedSheet: AppRoute?
    @Published var presentedFullScreen: AppRoute?
    
    // MARK: - Private Properties
    
    private var routeStack: [AppRoute] = []
    private var lastNavigationTime: Date = .distantPast
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Configuration
    
    private let config = RouterConfiguration()
    
    struct RouterConfiguration {
        let maxDepth: Int = 15
        let debounceInterval: TimeInterval = 0.3
        let duplicateWindowInterval: TimeInterval = 0.8
        let maxIdenticalConsecutiveRoutes: Int = 3
    }
    
    // MARK: - Initialization
    
    init() {
        $path
            .map { _ in self.path.count }
            .removeDuplicates()
            .sink { [weak self] newCount in
                self?.syncStackWithPath(newCount: newCount)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Path Synchronization
    
    private func syncStackWithPath(newCount: Int) {
        let currentCount = routeStack.count

        if newCount < currentCount {
            let itemsToRemove = currentCount - newCount
            for _ in 0..<itemsToRemove {
                if !routeStack.isEmpty {
                    routeStack.removeLast()
                }
            }
            lastNavigationTime = Date()
        }
    }
    
    // MARK: - Push Navigation
    
    func push(_ route: AppRoute) {
        let now = Date()

        guard now.timeIntervalSince(lastNavigationTime) >= config.debounceInterval else {
            return
        }

        guard routeStack.count < config.maxDepth else {
            return
        }

        if let lastRoute = routeStack.last,
           lastRoute == route,
           now.timeIntervalSince(lastNavigationTime) < config.duplicateWindowInterval {
            return
        }

        let recentRoutes = routeStack.suffix(config.maxIdenticalConsecutiveRoutes)
        if recentRoutes.count == config.maxIdenticalConsecutiveRoutes &&
           recentRoutes.allSatisfy({ $0 == route }) {
            return
        }

        lastNavigationTime = now
        path.append(route)
        routeStack.append(route)
    }
    
    // MARK: - Pop Navigation (Manual - for programmatic use)
    
    func pop() {
        guard !routeStack.isEmpty else { return }

        routeStack.removeLast()
        path.removeLast()
        lastNavigationTime = Date()
    }

    func popToRoot() {
        let count = routeStack.count
        guard count > 0 else { return }

        path.removeLast(count)
        routeStack.removeAll()
        lastNavigationTime = Date()
    }
    
    func pop(count: Int) {
        let actualCount = min(count, routeStack.count)
        guard actualCount > 0 else { return }
        
        path.removeLast(actualCount)
        routeStack.removeLast(actualCount)
        lastNavigationTime = Date()
    }
    
    func popTo(_ route: AppRoute) {
        guard let index = routeStack.lastIndex(of: route) else {
            return
        }
        
        let itemsToRemove = routeStack.count - index - 1
        guard itemsToRemove > 0 else { return }
        
        path.removeLast(itemsToRemove)
        routeStack.removeLast(itemsToRemove)
        lastNavigationTime = Date()
    }
    
    func replace(with route: AppRoute) {
        guard !routeStack.isEmpty else {
            push(route)
            return
        }

        routeStack.removeLast()
        path.removeLast()
        path.append(route)
        routeStack.append(route)
        lastNavigationTime = Date()
    }
    
    // MARK: - Modal Navigation
    
    func presentSheet(_ route: AppRoute) {
        let now = Date()
        guard now.timeIntervalSince(lastNavigationTime) >= config.debounceInterval else {
            return
        }
        
        lastNavigationTime = now
        presentedSheet = route
    }
    
    func presentFullScreen(_ route: AppRoute) {
        let now = Date()
        guard now.timeIntervalSince(lastNavigationTime) >= config.debounceInterval else {
            return
        }
        
        lastNavigationTime = now
        presentedFullScreen = route
    }
    
    func dismissSheet() {
        presentedSheet = nil
        lastNavigationTime = Date()
    }
    
    func dismissFullScreen() {
        presentedFullScreen = nil
        lastNavigationTime = Date()
    }
    
    // MARK: - State Queries
    
    var currentRoute: AppRoute? {
        routeStack.last
    }
    
    var depth: Int {
        routeStack.count
    }
    
    func isCurrentRoute(_ route: AppRoute) -> Bool {
        routeStack.last == route
    }
    
    func contains(_ route: AppRoute) -> Bool {
        routeStack.contains(route)
    }
    
    func reset() {
        popToRoot()
        presentedSheet = nil
        presentedFullScreen = nil
        lastNavigationTime = Date()
    }
    
    // MARK: - Debug

    func printStack() {
        #if DEBUG
        if routeStack.isEmpty {
            AppState.shared.log("[Router] (empty)")
        } else {
            for (index, route) in routeStack.enumerated() {
                let indicator = index == routeStack.count - 1 ? ">" : " "
                AppState.shared.log("[Router] \(indicator) [\(index)] \(route.id)")
            }
        }
        #endif
    }
}
