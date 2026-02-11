//
//  ImageViewerView.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//

import SwiftUI
import Kingfisher

struct ImageViewerView: View {
    @EnvironmentObject private var router: AppRouter
    
    let imageURL: URL
    let heroTag: String
    
    // MARK: - State Properties
    
    @GestureState private var magnifyBy: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            // Black Background
            Color.black
                .ignoresSafeArea()
            
            // Image with Zoom & Pan
            imageView
            
            // UI Overlay
            VStack {
                // Top Controls
                HStack {
                    Spacer()
                    closeButton
                }
                .padding()
                
                Spacer()
                
                // Bottom Info
                if scale > 1 {
                    zoomIndicator
                        .padding(.bottom, 40)
                }
            }
        }
        .statusBarHidden()
    }
    
    // MARK: - Image View
    
    private var imageView: some View {
        KFImage(imageURL)
            .placeholder {
                SkeletonRect(height: 300, cornerRadius: 0)
            }
            .retry(maxCount: 3, interval: .seconds(2))
            .onFailure { error in
                AppState.shared.log("Image loading failed: \(error)")
            }
            .resizable()
            .scaledToFit()
            .scaleEffect(scale * magnifyBy)
            .offset(offset)
            .gesture(magnificationGesture)
            .simultaneousGesture(dragGesture)
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded { _ in
                        toggleZoom()
                    }
            )
    }
    
    // MARK: - Close Button
    
    private var closeButton: some View {
        Button {
            router.dismissFullScreen()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.5))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    // MARK: - Zoom Indicator
    
    private var zoomIndicator: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .medium))
            
            Text("\(Int(scale * 100))%")
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.6))
        )
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Gestures
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { value in
                let newScale = scale * value
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    if newScale < 1 {
                        // Reset to original
                        scale = 1
                        offset = .zero
                        lastOffset = .zero
                    } else if newScale > 4 {
                        // Max zoom
                        scale = 4
                    } else {
                        scale = newScale
                    }
                }
            }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > 1 else { return }
                
                isDragging = true
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { value in
                isDragging = false
                lastOffset = offset
                constrainOffset()
            }
    }
    
    // MARK: - Actions
    
    private func toggleZoom() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if scale > 1 {
                // Zoom out
                scale = 1
                offset = .zero
                lastOffset = .zero
            } else {
                // Zoom in to 2x
                scale = 2
            }
        }
    }
    
    private func constrainOffset() {
        let maxOffset: CGFloat = 100 * scale

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            offset.width = max(-maxOffset, min(maxOffset, offset.width))
            offset.height = max(-maxOffset, min(maxOffset, offset.height))
            lastOffset = offset
        }
    }
}
