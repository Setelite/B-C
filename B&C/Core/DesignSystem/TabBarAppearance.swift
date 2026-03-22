import SwiftUI
import UIKit

enum TabBarAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.selectionIndicatorTintColor = UIColor(Color.brandPrimary.opacity(0.18))

        let normalColor = UIColor(Color.white.opacity(0.62))
        let selectedColor = UIColor(Color.brandPrimary)

        let stacked = appearance.stackedLayoutAppearance
        stacked.normal.iconColor = normalColor
        stacked.normal.titleTextAttributes = [
            .foregroundColor: normalColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        stacked.selected.iconColor = selectedColor
        stacked.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .bold)
        ]

        appearance.inlineLayoutAppearance = stacked
        appearance.compactInlineLayoutAppearance = stacked

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = selectedColor
        UITabBar.appearance().unselectedItemTintColor = normalColor
        UITabBar.appearance().barTintColor = .clear
    }
}
