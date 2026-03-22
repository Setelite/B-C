import SwiftUI

struct AIPlanUpdateCard: View {
    let updates: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .foregroundColor(.brandPrimary)
                Text("AI Update Plan")
                    .foregroundColor(.white)
                    .font(.headline)
            }

            if updates.isEmpty {
                Text("План без изменений")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.subheadline)
            } else {
                ForEach(updates, id: \.self) { item in
                    Text("• \(item)")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.subheadline)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ZStack {
        Color.bgPrimary.ignoresSafeArea()
        AIPlanUpdateCard(updates: ["Следующий подход в Тяга блока: 62 кг"])
            .padding()
    }
}
