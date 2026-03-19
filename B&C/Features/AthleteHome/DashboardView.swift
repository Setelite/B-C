import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var workoutSession: WorkoutSessionViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HeaderView()
                    TodayWorkoutCard()
                    AIRecommendationsCard(
                        recommendations: AICoach.analyzeProgress()
                    )
                    ProgressHistoryCard(items: workoutSession.progressHistory)
                    ProgressCard()
                    WeightChartCard()
                    StrengthChartCard()
                }
                .padding(16)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProgressHistoryCard: View {
    let items: [WorkoutSummaryItem]

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("История прогресса")
                .foregroundColor(.white)
                .font(.headline)

            if items.isEmpty {
                Text("Пока нет сохраненных тренировок")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.subheadline)
            } else {
                ForEach(items) { item in
                    HStack {
                        Text(formatter.string(from: item.date))
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Spacer()
                        Text(String(format: "%.0f кг • %d подходов", item.averageWeight, item.totalSets))
                            .foregroundColor(.white.opacity(0.7))
                            .font(.subheadline)
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

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Body&Code")
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Привет, Алексей")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "bell.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

struct TodayWorkoutCard: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AssetImageOrPlaceholder(name: "workout")
                .scaledToFill()
                .frame(height: 180)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.6), .clear],
                startPoint: .bottom,
                endPoint: .top
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Сегодняшняя тренировка")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Text("Спина и Бицепс")
                    .font(.title3.bold())
                    .foregroundColor(.white)

                Text("5 упражнений • 45 мин")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                PrimaryButton(title: "Начать тренировку") {
                    router.push(.todaysWorkout)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Мой Прогресс")
                .foregroundColor(.white)
                .font(.headline)

            HStack {
                stat(title: "6", subtitle: "недель подряд")
                Spacer()
                stat(title: "90 кг", subtitle: "Текущий вес")
                Spacer()
                stat(title: "120 кг", subtitle: "Максимальный")
            }

            ProgressView(value: 0.6)
                .tint(.green)
        }
        .padding(16)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func stat(title: String, subtitle: String) -> some View {
        VStack {
            Text(title)
                .foregroundColor(.white)
                .font(.title3.bold())

            Text(subtitle)
                .foregroundColor(.white.opacity(0.55))
                .font(.caption)
        }
    }
}

struct WeightChartCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Вес тела")
                .foregroundColor(.white)
                .font(.headline)

            Rectangle()
                .fill(Color.brandPrimary.opacity(0.25))
                .frame(height: 120)
                .overlay(
                    Text("График веса")
                        .foregroundColor(.white.opacity(0.6))
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(16)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct StrengthChartCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Сила")
                .foregroundColor(.white)
                .font(.headline)

            Rectangle()
                .fill(Color.blue.opacity(0.25))
                .frame(height: 120)
                .overlay(
                    Text("График силы")
                        .foregroundColor(.white.opacity(0.6))
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(16)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct AssetImageOrPlaceholder: View {
    let name: String

    var body: some View {
        if let uiImage = UIImage(named: name) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            ZStack {
                Color.card
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.55))
            }
        }
    }
}

#Preview {
    FlowCoordinatorView()
}
