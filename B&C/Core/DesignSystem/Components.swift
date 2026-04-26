import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(Color.card)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct PrimaryButton: View {
    let title: String
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    label
                }
            } else {
                label
            }
        }
    }

    private var label: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundColor(Color.buttonPrimaryText)
            .lineLimit(2)
            .minimumScaleFactor(0.85)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(Color.buttonPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 16) {
        CardView { Text("Card").foregroundStyle(Color.textPrimary) }
        PrimaryButton(title: "Continue")
        PrimaryButton(title: "Continue", action: {})
    }
    .padding()
    .background(Color.bgPrimary)
}
