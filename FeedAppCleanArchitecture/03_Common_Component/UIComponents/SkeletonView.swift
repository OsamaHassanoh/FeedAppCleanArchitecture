import SwiftUI

// MARK: - Shimmer Effect Modifier

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.0),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (phase * geometry.size.width * 3))
                }
            )
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Skeleton Shape Primitives

struct SkeletonRect: View {
    var width: CGFloat? = nil
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 4

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(.systemGray5))
            .frame(width: width, height: height)
            .shimmer()
    }
}

struct SkeletonCircle: View {
    var size: CGFloat = 40

    var body: some View {
        Circle()
            .fill(Color(.systemGray5))
            .frame(width: size, height: size)
            .shimmer()
    }
}

// MARK: - Feed Post Card Skeleton

struct FeedPostCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // User header
            HStack(spacing: 10) {
                SkeletonCircle(size: 40)
                SkeletonRect(width: 120, height: 14)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Post image
            SkeletonRect(height: UIScreen.main.bounds.width - 32, cornerRadius: 0)

            // Actions row
            HStack(spacing: 16) {
                SkeletonRect(width: 50, height: 14)
                SkeletonRect(width: 50, height: 14)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // Caption
            VStack(alignment: .leading, spacing: 6) {
                SkeletonRect(height: 12)
                SkeletonRect(width: 200, height: 12)
            }
            .padding(.horizontal, 16)

            // Timestamp
            SkeletonRect(width: 40, height: 10)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}

// MARK: - Feed Skeleton (Full Screen)

struct FeedSkeletonView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Section selector skeleton
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<4, id: \.self) { _ in
                        SkeletonRect(width: 70, height: 14)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 50)

            Divider()

            // Post cards skeleton
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { _ in
                        FeedPostCardSkeleton()
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

// MARK: - Post Detail Skeleton

struct PostDetailSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Post image
                SkeletonRect(height: UIScreen.main.bounds.width, cornerRadius: 0)

                VStack(alignment: .leading, spacing: 16) {
                    // User header
                    HStack {
                        SkeletonCircle(size: 48)
                        VStack(alignment: .leading, spacing: 6) {
                            SkeletonRect(width: 120, height: 14)
                            SkeletonRect(width: 80, height: 10)
                        }
                        Spacer()
                    }

                    // Like & comment counts
                    HStack(spacing: 24) {
                        SkeletonRect(width: 80, height: 14)
                        SkeletonRect(width: 100, height: 14)
                    }

                    Divider()

                    // Caption
                    VStack(alignment: .leading, spacing: 6) {
                        SkeletonRect(height: 14)
                        SkeletonRect(height: 14)
                        SkeletonRect(width: 180, height: 14)
                    }
                }
                .padding(16)
            }
        }
    }
}

// MARK: - User Profile Skeleton

struct UserProfileSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SkeletonCircle(size: 100)
                SkeletonRect(width: 150, height: 20, cornerRadius: 6)
                SkeletonRect(width: 100, height: 14)

                // Follow button
                SkeletonRect(height: 44, cornerRadius: 8)
                    .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 24)
        }
    }
}

// MARK: - Search Skeleton

struct SearchSkeletonView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Search bar placeholder
            SkeletonRect(height: 36, cornerRadius: 10)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

            // Result rows
            ForEach(0..<6, id: \.self) { _ in
                HStack(spacing: 12) {
                    SkeletonCircle(size: 44)
                    VStack(alignment: .leading, spacing: 6) {
                        SkeletonRect(width: 140, height: 14)
                        SkeletonRect(width: 90, height: 10)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }

            Spacer()
        }
    }
}
