import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
    static let bgPrimary = Color.dynamic(light: "#FFFFFF", dark: "#0F0F10")
    static let card = Color.dynamic(light: "#F4F4F5", dark: "#18181B")
    static let textPrimary = Color.dynamic(light: "#111111", dark: "#FAFAFA")
    static let textSecondary = Color.dynamic(light: "#6B7280", dark: "#A1A1AA")
    static let border = Color.dynamic(light: "#E5E7EB", dark: "#27272A")
    static let buttonPrimary = Color.dynamic(light: "#111111", dark: "#FAFAFA")
    static let buttonPrimaryText = Color.dynamic(light: "#FFFFFF", dark: "#111111")

    /// Brand accent color (Figma: "#FF7A00").
    /// Note: can't name it `primary` because SwiftUI already has `Color.primary`.
    static let brandPrimary = Color(hex: "#FF7A00")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func dynamic(light: String, dark: String) -> Color {
        Color(
            UIColor { trait in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(Color(hex: dark))
                } else {
                    return UIColor(Color(hex: light))
                }
            }
        )
    }
}
