import SwiftUI

struct AthleteHomeView: View {
    var body: some View {
        DashboardView()
    }
}

struct TodaysWorkoutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Тренировка на сегодня")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Детали тренировки")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Упражнения, подходы, инструкции")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))

                        PrimaryButton(title: "Открыть детали") {
                            router.push(.workoutDetail)
                        }
                    }
                }

                PrimaryButton(title: "Начать тренировку") {
                    router.push(.startWorkoutScreen)
                }
            }
            .padding(16)
        }
        .background(Color.bgPrimary)
        .navigationTitle("Today's Workout")
    }
}

#Preview {
    FlowCoordinatorView()
}

