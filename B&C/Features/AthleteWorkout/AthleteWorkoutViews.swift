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
                    PrimaryButton(title: "Начать") { router.push(.workoutView) }
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
                    PrimaryButton(title: "Log Set") { router.push(.workoutView) }
                    PrimaryButton(title: "Next Exercise") { router.push(.nextExercise) }
                    PrimaryButton(title: "Завершить тренировку") { router.push(.completeWorkout) }
                }
            }
            .padding(16)
        }
    }
}

struct WorkoutView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel

    @State private var weight: String = ""
    @State private var reps: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text(workoutViewModel.currentExerciseName)
                .font(.title2)
                .foregroundColor(.white)

            if let plan = workoutViewModel.currentProgram.exercises.first(where: { $0.name == workoutViewModel.currentExerciseName }) {
                Text("План: \(Int(plan.plannedWeight)) кг × \(plan.targetReps)")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.subheadline)
            }

            Text("Упражнение \(workoutViewModel.currentExerciseIndex + 1) из \(max(workoutViewModel.currentProgram.exercises.count, 1))")
                .foregroundColor(.white.opacity(0.7))
                .font(.caption)

            ForEach(workoutViewModel.currentSets.indices, id: \.self) { i in
                let set = workoutViewModel.currentSets[i]
                Text("\(Int(set.weight)) кг × \(set.reps)")
                    .foregroundColor(.white)
            }

            HStack {
                TextField("Вес", text: $weight)
                    .keyboardType(.decimalPad)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                TextField("Повторы", text: $reps)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            PrimaryButton(title: "Сохранить подход") {
                if let w = Double(weight.replacingOccurrences(of: ",", with: ".")),
                   let r = Int(reps) {
                    workoutViewModel.logSet(weight: w, reps: r)
                    weight = ""
                    reps = ""
                }
            }

            PrimaryButton(title: "Следующее упражнение") {
                if workoutViewModel.nextExercise() {
                    weight = ""
                    reps = ""
                }
            }

            PrimaryButton(title: "Завершить тренировку") {
                workoutViewModel.finishWorkout()
                router.push(.saveWorkoutData)
                router.push(.workoutSummary)
            }

            if !workoutViewModel.planUpdates.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(workoutViewModel.planUpdates, id: \.self) { update in
                        Text("✅ \(update)")
                            .foregroundColor(.green)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(workoutViewModel.recommendations, id: \.self) { rec in
                    Text("👉 \(rec)")
                        .foregroundColor(.orange)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.bgPrimary)
    }
}

struct LogSetView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @State private var weightText: String = ""
    @State private var repsText: String = ""
    @State private var showValidation: Bool = false

    var body: some View {
        AppScreen(
            title: "Log Set",
            subtitle: "Вес • Повторения • RPE • Заметки"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(workoutViewModel.currentExerciseName)
                        .foregroundColor(.white)
                        .font(.headline)

                    ForEach(workoutViewModel.currentSets.indices, id: \.self) { i in
                        let set = workoutViewModel.currentSets[i]
                        Text("\(Int(set.weight)) кг × \(set.reps)")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }

                    HStack(spacing: 8) {
                        TextField("Вес", text: $weightText)
                            .keyboardType(.decimalPad)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        TextField("Повторы", text: $repsText)
                            .keyboardType(.numberPad)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }

                    if showValidation {
                        Text("Введите корректные вес и повторы")
                            .foregroundColor(.red.opacity(0.9))
                            .font(.caption)
                    }

                    PrimaryButton(title: "Сохранить подход") {
                        guard let w = Double(weightText.replacingOccurrences(of: ",", with: ".")),
                              let r = Int(repsText),
                              w > 0, r > 0 else {
                            showValidation = true
                            return
                        }
                        showValidation = false
                        workoutViewModel.logSet(weight: w, reps: r)
                        weightText = ""
                        repsText = ""
                    }

                    PrimaryButton(title: "Завершить тренировку") {
                        workoutViewModel.finishWorkout()
                        router.push(.workoutSummary)
                    }

                    PrimaryButton(title: "Следующий подход") { router.pop() }
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
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel

    var body: some View {
        AppScreen(
            title: "Complete Workout",
            subtitle: "Общая оценка • Заметки • Самочувствие"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Завершить тренировку") {
                        workoutViewModel.finishWorkout()
                        router.push(.saveWorkoutData)
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
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel

    var body: some View {
        AppScreen(
            title: "Workout Summary",
            subtitle: "Статистика • Сравнение с прошлым разом"
        )
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                AIRecommendationsCard(recommendations: workoutViewModel.recommendations)
                AIPlanUpdateCard(updates: workoutViewModel.planUpdates)

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
