import SwiftUI

struct ProgramsLibraryView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Programs Library",
            subtitle: "Мои программы • Шаблоны • Архив"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Create Program (Screen)") { router.push(.createProgramScreen) }
                    PrimaryButton(title: "Program Builder") { router.push(.programBuilder) }
                    PrimaryButton(title: "Empty State: No Programs") { router.push(.emptyStateNoPrograms) }
                }
            }
            .padding(16)
        }
    }
}

struct CreateProgramScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Create Program Screen",
            subtitle: "Название • Длительность • Цель"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Program Builder") { router.push(.programBuilder) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct ProgramBuilderView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Program Builder",
            subtitle: "Добавление недель и тренировок"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Add Week") { router.push(.addWeek) }
                    PrimaryButton(title: "Save Program") { router.push(.saveProgram) }
                    PrimaryButton(title: "Error: Save Failed") { router.push(.errorSaveFailed) }
                }
            }
            .padding(16)
        }
    }
}

struct AddWeekView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Add Week",
            subtitle: "Количество тренировок • Фокус"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Add Workout") { router.push(.addWorkout) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct AddWorkoutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Add Workout",
            subtitle: "Название • Тип • Упражнения"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Workout Builder") { router.push(.workoutBuilder) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct WorkoutBuilderView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Workout Builder",
            subtitle: "Добавление упражнений • Подходов • Повторений"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Exercise Library") { router.push(.exerciseLibrary) }
                    PrimaryButton(title: "Share Workout") { router.push(.sendMessage) }
                    PrimaryButton(title: "Save Program") { router.push(.saveProgram) }
                }
            }
            .padding(16)
        }
    }
}

struct ExerciseLibraryView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Exercise Library",
            subtitle: "Поиск • Фильтры • Видео инструкции"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Выбрать упражнение") { router.push(.addExerciseToWorkout) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct AddExerciseToWorkoutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Add Exercise to Workout",
            subtitle: "Подходы • Повторения • Вес • Темп • Отдых"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Back to Workout Builder") { router.pop() }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}

