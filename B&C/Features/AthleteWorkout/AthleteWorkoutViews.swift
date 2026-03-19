import SwiftUI

struct StartWorkoutScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Start Workout Screen",
            subtitle: "Таймер • Текущее упражнение"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Начать") { router.push(.exerciseExecution) }
                    PrimaryButton(title: "Нет интернета") { router.push(.offlineMode) }
                }
            }
            .padding(16)
        }
    }
}

struct WorkoutDetailView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Workout Detail",
            subtitle: "Упражнения • Подходы • Инструкции"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Start Workout") { router.push(.startWorkoutScreen) }
            }
            .padding(16)
        }
    }
}

struct ExerciseExecutionView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Exercise Execution",
            subtitle: "Видео • Таймер отдыха • Логирование"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Log Set") { router.push(.logSet) }
                    PrimaryButton(title: "Next Exercise") { router.push(.nextExercise) }
                    PrimaryButton(title: "Завершить тренировку") { router.push(.completeWorkout) }
                }
            }
            .padding(16)
        }
    }
}

struct LogSetView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var workoutSession: WorkoutSessionViewModel
    @State private var weightText: String = ""
    @State private var reps: Int = 8
    @State private var showValidation: Bool = false

    var body: some View {
        AppScreen(
            title: "Log Set",
            subtitle: "Вес • Повторения • RPE • Заметки"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(workoutSession.currentExerciseName)
                        .foregroundColor(.white)
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Вес (кг)")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.caption)
                        TextField("Например, 60", text: $weightText)
                            .keyboardType(.decimalPad)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }

                    Stepper(value: $reps, in: 1...50) {
                        Text("Повторения: \(reps)")
                            .foregroundColor(.white)
                    }
                    .tint(.brandPrimary)

                    if showValidation {
                        Text("Введите корректный вес")
                            .foregroundColor(.red.opacity(0.9))
                            .font(.caption)
                    }

                    PrimaryButton(title: "Сохранить подход") {
                        guard let weight = Double(weightText.replacingOccurrences(of: ",", with: ".")),
                              weight > 0 else {
                            showValidation = true
                            return
                        }
                        showValidation = false
                        workoutSession.logSet(weight: weight, reps: reps)
                        weightText = ""
                        reps = 8
                        router.pop()
                    }
                }
            }
            .padding(16)
        }
    }
}

struct NextExerciseView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Next Exercise",
            subtitle: "Переход к следующему упражнению"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Exercise Execution") { router.push(.exerciseExecution) }
            }
            .padding(16)
        }
    }
}

struct CompleteWorkoutV2View: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var workoutSession: WorkoutSessionViewModel

    var body: some View {
        AppScreen(
            title: "Complete Workout",
            subtitle: "Общая оценка • Заметки • Самочувствие"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Завершить и сохранить") {
                        workoutSession.finishWorkout()
                        router.push(.workoutSummary)
                    }
                    PrimaryButton(title: "Save Workout Data") { router.push(.saveWorkoutData) }
                }
            }
            .padding(16)
        }
    }
}

struct WorkoutSummaryView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var workoutSession: WorkoutSessionViewModel

    var body: some View {
        AppScreen(
            title: "Workout Summary",
            subtitle: "Статистика • Сравнение с прошлым разом"
        )
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                AIRecommendationsCard(recommendations: workoutSession.recommendations)

                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Backend: Recalculate Progress") { router.push(.backendRecalculateProgress) }
                        PrimaryButton(title: "Back to Home") { router.goToDashboard() }
                    }
                }
            }
            .padding(16)
        }
    }
}

struct OfflineModeView: View {
    var body: some View {
        AppScreen(
            title: "Offline Mode",
            subtitle: "Локальное сохранение • Синхронизация позже"
        )
    }
}

#Preview {
    FlowCoordinatorView()
}
