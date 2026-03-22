import SwiftUI

struct ProgramsLibraryView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel

    var body: some View {
        AppScreen(
            title: "Programs Library",
            subtitle: "Мои программы • Шаблоны • Архив"
        )
        .onAppear {
            programsViewModel.load()
        }
        .safeAreaInset(edge: .top) {
            CardView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Всего программ")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.72))
                        Spacer()
                        Text("\(programsViewModel.totalPrograms)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }

                    HStack {
                        Text("Назначено клиентам")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.72))
                        Spacer()
                        Text("\(programsViewModel.totalAssignedClients)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }

                    Divider().overlay(.white.opacity(0.14))

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(programsViewModel.topPrograms) { item in
                            HStack {
                                Button {
                                    programsViewModel.startEditDraft(programID: item.id)
                                    router.push(.programBuilder)
                                } label: {
                                    HStack {
                                        Text(item.name)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text("\(item.assignedClients) клиентов • \(item.phaseText)")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.72))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Create Program (Screen)") {
                        programsViewModel.startCreateDraft()
                        router.push(.createProgramScreen)
                    }
                    PrimaryButton(title: "Program Builder") {
                        programsViewModel.startCreateDraft()
                        router.push(.programBuilder)
                    }
                    PrimaryButton(title: "Empty State: No Programs") { router.push(.emptyStateNoPrograms) }
                }
            }
            .padding(16)
        }
    }
}

struct CreateProgramScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel

    @State private var name: String = ""
    @State private var category: CoachProgramCategory = .strength
    @State private var totalWeeks: Int = 8

    var body: some View {
        AppScreen(
            title: "Create Program Screen",
            subtitle: "Название • Длительность • Цель"
        )
        .safeAreaInset(edge: .top) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Название программы", text: $name)
                        .textInputAutocapitalization(.words)
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Picker("Категория", selection: $category) {
                        ForEach(CoachProgramCategory.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.menu)

                    Stepper("Длительность: \(totalWeeks) нед.", value: $totalWeeks, in: 1...24)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Program Builder") {
                        programsViewModel.startCreateDraft(
                            name: name,
                            category: category,
                            totalWeeks: totalWeeks
                        )
                        router.push(.programBuilder)
                    }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct ProgramBuilderView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel

    @State private var errorMessage: String?

    var body: some View {
        AppScreen(
            title: "Program Builder",
            subtitle: "Добавление недель и тренировок"
        )
        .onAppear {
            if programsViewModel.builderDraft == .empty {
                programsViewModel.startCreateDraft()
            }
        }
        .safeAreaInset(edge: .top) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    TextField(
                        "Название программы",
                        text: Binding(
                            get: { programsViewModel.builderDraft.name },
                            set: { programsViewModel.builderDraft.name = $0 }
                        )
                    )
                    .textInputAutocapitalization(.words)
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.14), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Picker(
                        "Категория",
                        selection: Binding(
                            get: { programsViewModel.builderDraft.category },
                            set: { programsViewModel.builderDraft.category = $0 }
                        )
                    ) {
                        ForEach(CoachProgramCategory.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.menu)

                    Stepper(
                        "Клиентов: \(programsViewModel.builderDraft.assignedClients)",
                        value: Binding(
                            get: { programsViewModel.builderDraft.assignedClients },
                            set: { programsViewModel.builderDraft.assignedClients = max(0, $0) }
                        ),
                        in: 0...200
                    )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                    Stepper(
                        "Текущая неделя: \(programsViewModel.builderDraft.currentWeek)",
                        value: Binding(
                            get: { programsViewModel.builderDraft.currentWeek },
                            set: { programsViewModel.builderDraft.currentWeek = max(1, min($0, programsViewModel.builderDraft.totalWeeks)) }
                        ),
                        in: 1...24
                    )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                    Stepper(
                        "Всего недель: \(programsViewModel.builderDraft.totalWeeks)",
                        value: Binding(
                            get: { programsViewModel.builderDraft.totalWeeks },
                            set: {
                                programsViewModel.builderDraft.totalWeeks = max(1, $0)
                                programsViewModel.builderDraft.currentWeek = min(
                                    programsViewModel.builderDraft.currentWeek,
                                    programsViewModel.builderDraft.totalWeeks
                                )
                            }
                        ),
                        in: 1...24
                    )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Add Week") { router.push(.addWeek) }
                    PrimaryButton(title: "Save Program") {
                        switch programsViewModel.saveDraft() {
                        case .success:
                            errorMessage = nil
                            router.pop()
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
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
