import SwiftUI

struct AIPlanUpdateCard: View {
    let updates: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .foregroundColor(.brandPrimary)
                Text("AI Обновление плана")
                    .foregroundStyle(Color.textPrimary)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
            }

            if updates.isEmpty {
                Text("План без изменений")
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            } else {
                ForEach(updates, id: \.self) { item in
                    Text("• \(item)")
                        .foregroundStyle(Color.textPrimary)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .lineLimit(3)
                        .minimumScaleFactor(0.82)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
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
