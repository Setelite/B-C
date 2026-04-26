import SwiftUI
import UIKit

enum TabBarAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = UIColor(Color.bgPrimary)
        appearance.shadowColor = UIColor(Color.border)
        appearance.selectionIndicatorTintColor = UIColor(Color.brandPrimary.opacity(0.14))

        let normalColor = UIColor(Color.textSecondary)
        let selectedColor = UIColor(Color.textPrimary)

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
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = selectedColor
        UITabBar.appearance().unselectedItemTintColor = normalColor
        UITabBar.appearance().barTintColor = UIColor(Color.bgPrimary)
    }
}
