import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.bgPrimary, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.brandPrimary.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 40)
                .offset(x: 140, y: -260)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 28)
                .offset(x: -160, y: 220)

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HeaderView()
                    TodayWorkoutCard()
                    AIRecommendationsCard(
                        recommendations: AICoach.analyzeProgress()
                    )
                    ProgressHistoryCard(items: workoutViewModel.progressHistory)
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

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Body&Code")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))

                Text("Привет, Алексей")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "bell.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.white.opacity(0.08))
                .overlay(
                    Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
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
                .font(.system(size: 18, weight: .bold, design: .rounded))

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
        .glassCardStyle()
    }
}

struct ProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Мой Прогресс")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))

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
        .glassCardStyle()
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
                .font(.system(size: 18, weight: .bold, design: .rounded))

            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.brandPrimary.opacity(0.30), Color.brandPrimary.opacity(0.10)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay(
                    Text("График веса")
                        .foregroundColor(.white.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        }
        .glassCardStyle()
    }
}

struct StrengthChartCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Сила")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))

            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.30), Color.blue.opacity(0.10)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay(
                    Text("График силы")
                        .foregroundColor(.white.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        }
        .glassCardStyle()
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

private struct NoiseOverlay: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let dotCount = 2400
                var rng = SeededGenerator(seed: 77)
                for _ in 0..<dotCount {
                    let x = CGFloat.random(in: 0...size.width, using: &rng)
                    let y = CGFloat.random(in: 0...size.height, using: &rng)
                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(.white.opacity(0.08)))
                }
            }
            .blur(radius: 0.6)
        }
        .allowsHitTesting(false)
    }
}

private struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private extension View {
    func glassCardStyle() -> some View {
        modifier(GlassCardModifier())
    }
}

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1
        return state
    }
}
