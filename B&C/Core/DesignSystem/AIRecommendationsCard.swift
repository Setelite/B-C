import SwiftUI

struct AIRecommendationsCard: View {
    let recommendations: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text("AI Рекомендации")
                    .foregroundColor(.white)
                    .font(.headline)
            }

            if recommendations.isEmpty {
                Text("Нет рекомендаций")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.subheadline)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recommendations, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(Color.brandPrimary)
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            Text(item)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
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
        AIRecommendationsCard(recommendations: ["Увеличь рабочий вес", "Сохраняй стабильный объем"])
            .padding()
    }
}
