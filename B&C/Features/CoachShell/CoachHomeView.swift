import SwiftUI

struct CoachHomeView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Привет, Максим")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Сводка по клиентам")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Активные программы, уведомления, последняя активность")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))

                        PrimaryButton(title: "Открыть клиентов") {
                            router.push(.clientsList)
                        }
                    }
                }

                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Программы")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Библиотека программ и конструктор")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))

                        PrimaryButton(title: "Открыть программы") {
                            router.push(.programsLibrary)
                        }
                    }
                }

                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Аналитика")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Тренды, рекомендации, корректировки")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))

                        PrimaryButton(title: "Progress Analytics") {
                            router.push(.progressAnalytics)
                        }
                        PrimaryButton(title: "AI Insights (Future)") {
                            router.push(.aiInsights)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.bgPrimary)
        .navigationTitle("Home")
    }
}

#Preview {
    FlowCoordinatorView()
}
