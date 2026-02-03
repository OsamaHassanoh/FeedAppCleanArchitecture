//
//  ThemeManager.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Combine
import Foundation
import SwiftUI

/**
 Protocol for themes
 */
protocol ThemeFonts {
    var largeTitleFont: Font { get }
    var textTitleFont: Font { get }
    var normalBtnTitleFont: Font { get }
    var boldBtnTitleFont: Font { get }
    var titleTextFont: Font { get }
    var bodyTextFont: Font { get }
    var mediumBodyTextFont: Font { get }
    var captionTxtFont: Font { get }
    var smalBodyTextFont: Font { get }
    var smalestBodyTextFont: Font { get }
}

protocol ThemeColors {
    var primaryThemeColor: Color { get }
    var secondaryThemeColor: Color { get }
    var reviewsThemeColor: Color { get }
    var editThemeColor: Color { get }
    var negativeBtnTitleColor: Color { get }
    var bodyTextColor: Color { get }
    var titleTextColor: Color { get }
    var textBoxColor: Color { get }
    var ButtonBg: Color { get }
    var likedBg: Color { get }
}

class ThemeManager: ObservableObject {
    @Published var selectedTheme: Theme = MainTheme()

    func setTheme(_ theme: Theme) {
        selectedTheme = theme
    }

    func updateTheme(for colorScheme: ColorScheme) {
        selectedTheme = colorScheme == .dark ? DarkTheme() : MainTheme()
    }
}

// MARK: - Theme Protocol

protocol Theme {
    var fonts: ThemeFonts { get }
    var colors: ThemeColors { get }
}

// MARK: - Theme Implementation (Main Theme)

struct MainTheme: Theme {
    struct Fonts: ThemeFonts {
        var largeTitleFont: Font = .custom("NotoKufiArabic-ExtraBold", size: 30)
        var textTitleFont: Font = .custom("NotoKufiArabic-ExtraBold", size: 24)
        var normalBtnTitleFont: Font = .custom("NotoKufiArabic-SemiBold", size: 20)
        var boldBtnTitleFont: Font = .custom("NotoKufiArabic-Bold", size: 18)
        var titleTextFont: Font = .custom("NotoKufiArabic-SemiBold", size: 16)
        var bodyTextFont: Font = .custom("NotoKufiArabic-SemiBold", size: 16)
        var mediumBodyTextFont: Font = .custom("NotoKufiArabic-SemiBold", size: 14)
        var captionTxtFont: Font = .custom("NotoKufiArabic-SemiBold", size: 20)
        var smalBodyTextFont: Font = .custom("NotoKufiArabic-Light", size: 16)
        var smalestBodyTextFont: Font = .custom("NotoKufiArabic-Light", size: 14)
    }

    struct Colors: ThemeColors {
        var primaryThemeColor: Color {
            Color("PrimaryThemeColor")
        }

        var secondaryThemeColor: Color {
            Color("mnSecondaryThemeColor")
        }

        var reviewsThemeColor: Color {
            Color("ReviewsThemeColor")
        }

        var editThemeColor: Color {
            Color("EditThemeColor")
        }

        var negativeBtnTitleColor: Color {
            Color("mnNegativeBtnTitleColor")
        }

        var titleTextColor: Color {
            Color("mntitleTextColor")
        }

        var bodyTextColor: Color {
            Color("mnBodyTextColor")
        }

        var textBoxColor: Color {
            Color("mnTextBoxColor")
        }

        var imageTntColor: Color {
            Color("ImageTnt")
        }

        var ButtonBg: Color {
            Color("ButtonTnt")
        }

        var likedBg: Color {
            Color("likedBg")
        }
    }

    var fonts: ThemeFonts = Fonts()
    var colors: ThemeColors = Colors()
}

struct DarkTheme: Theme {
    struct Fonts: ThemeFonts {
        var largeTitleFont: Font = .custom("NotoKufiArabic-ExtraBold", size: 30)
        var textTitleFont: Font = .custom("NotoKufiArabic-ExtraBold", size: 24)
        var normalBtnTitleFont: Font = .custom("NotoKufiArabic-SemiBold", size: 20)
        var boldBtnTitleFont: Font = .custom("NotoKufiArabic-Bold", size: 18)
        var titleTextFont: Font = .custom("NotoKufiArabic-SemiBold", size: 16)
        var bodyTextFont: Font = .custom("NotoKufiArabic-SemiBold", size: 16)
        var mediumBodyTextFont: Font = .custom("NotoKufiArabic-SemiBold", size: 14)
        var captionTxtFont: Font = .custom("NotoKufiArabic-SemiBold", size: 20)
        var smalBodyTextFont: Font = .custom("NotoKufiArabic-Light", size: 16)
        var smalestBodyTextFont: Font = .custom("NotoKufiArabic-Light", size: 14)
    }

    struct Colors: ThemeColors {
        var primaryThemeColor: Color {
            Color("mnPrimaryThemeColor")
        }

        var secondaryThemeColor: Color {
            Color("mnSecondaryThemeColor")
        }

        var reviewsThemeColor: Color {
            Color("ReviewsThemeColor")
        }

        var editThemeColor: Color {
            Color("EditThemeColor")
        }

        var negativeBtnTitleColor: Color {
            Color("mnNegativeBtnTitleColor")
        }

        var titleTextColor: Color {
            Color("mntitleTextColor")
        }

        var bodyTextColor: Color {
            Color.black
        } // { Color("mnBodyTextColor") }
        var textBoxColor: Color {
            Color("mnTextBoxColor")
        }

        var imageTntColor: Color {
            Color("ImageTnt")
        }

        var ButtonBg: Color {
            Color("ButtonTnt")
        }

        var likedBg: Color {
            Color("likedBg")
        }
    }

    var fonts: ThemeFonts = Fonts()
    var colors: ThemeColors = Colors()
}
