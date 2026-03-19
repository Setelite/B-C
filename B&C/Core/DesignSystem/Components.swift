import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(Color.brandPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 16) {
        CardView { Text("Card").foregroundStyle(.white) }
        PrimaryButton(title: "Continue")
        PrimaryButton(title: "Continue", action: {})
    }
    .padding()
    .background(Color.bgPrimary)
}

