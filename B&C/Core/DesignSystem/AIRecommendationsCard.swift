import SwiftUI

struct AIRecommendationsCard: View {
    let recommendations: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.brandPrimary)
                Text("AI Рекомендации")
                    .foregroundStyle(Color.textPrimary)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
            }

            if recommendations.isEmpty {
                Text("Нет рекомендаций")
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recommendations, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(Color.brandPrimary)
                                .frame(width: 7, height: 7)
                                .padding(.top, 6)
                            Text(item)
                                .foregroundStyle(Color.textPrimary)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .lineLimit(3)
                                .minimumScaleFactor(0.8)
                        }
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    ZStack {
        Color.bgPrimary.ignoresSafeArea()
        AIRecommendationsCard(recommendations: ["Увеличь рабочий вес", "Сохраняй стабильный объем"])
            .padding()
    }
}
