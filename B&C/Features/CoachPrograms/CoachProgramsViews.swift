import SwiftUI

struct ProgramsLibraryView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel

    @State private var selectedProgramForAssignment: CoachProgramListItem?

    var body: some View {
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    summaryCard
                    quickActions
                    howItWorksCard
                    categoriesCard
                    programsList
                }
                .padding(16)
            }
        }
        .navigationTitle("Программы")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            programsViewModel.load()
            clientsViewModel.load()
        }
        .sheet(item: $selectedProgramForAssignment) { program in
            ProgramAssignSheet(program: program)
                .environmentObject(programsViewModel)
                .environmentObject(clientsViewModel)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Программы")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            Text("Библиотека программ, конструктор и отправка подопечным")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
    }

    private var summaryCard: some View {
        VStack(spacing: 10) {
            HStack {
                MetricTile(title: "Программ", value: "\(programsViewModel.totalPrograms)")
                MetricTile(title: "Назначений", value: "\(programsViewModel.totalAssignedClients)")
                MetricTile(title: "Ср. выполнение", value: "\(programsViewModel.averageProgramCompletion)%")
            }
        }
        .glassCardStyle()
    }

    private var quickActions: some View {
        VStack(spacing: 10) {
            BigActionButton(title: "Конструктор программы", subtitle: "Собери персональный план", icon: "square.and.pencil") {
                programsViewModel.startCreateDraft()
                router.push(.programBuilder)
            }
            BigActionButton(title: "База упражнений", subtitle: "Категории по группам мышц", icon: "books.vertical.fill") {
                router.push(.exerciseLibrary)
            }
            BigActionButton(title: "Создать и назначить", subtitle: "Подготовь программу и отправь подопечному", icon: "paperplane.fill") {
                programsViewModel.startCreateDraft()
                router.push(.createProgramScreen)
            }
        }
    }

    private var howItWorksCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Как использовать")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            Text("1. Открой конструктор и собери программу.")
                .foregroundStyle(Color.textSecondary)
            Text("2. Добавь упражнения из базы по группам мышц.")
                .foregroundStyle(Color.textSecondary)
            Text("3. Нажми \"Назначить клиенту\" в карточке программы.")
                .foregroundStyle(Color.textSecondary)
        }
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .glassCardStyle()
    }

    private var categoriesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Категории")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            ForEach(programsViewModel.categoryMetrics) { metric in
                HStack {
                    Label(metric.category.title, systemImage: metric.category.iconName)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("\(metric.count)")
                        .foregroundStyle(Color.textPrimary)
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
        }
        .glassCardStyle()
    }

    private var programsList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Программы в библиотеке")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            ForEach(programsViewModel.programs) { program in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(program.name)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Spacer()
                        Text("\(program.assignedClients) клиентов")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.textSecondary)
                    }

                    HStack(spacing: 8) {
                        SmallActionButton(title: "Открыть конструктор", icon: "pencil") {
                            programsViewModel.startEditDraft(programID: program.id)
                            router.push(.programBuilder)
                        }
                        SmallActionButton(title: "Назначить клиенту", icon: "paperplane") {
                            selectedProgramForAssignment = program
                        }
                    }
                }
                .glassCardStyle()
            }
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
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            VStack(spacing: 12) {
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Название программы", text: $name)
                            .textInputAutocapitalization(.words)
                            .padding(12)
                            .background(Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Picker("Категория", selection: $category) {
                            ForEach(CoachProgramCategory.allCases) { item in
                                Text(item.title).tag(item)
                            }
                        }
                        .pickerStyle(.menu)

                        Stepper("Длительность: \(totalWeeks) нед.", value: $totalWeeks, in: 1...24)
                            .foregroundStyle(Color.textPrimary)
                    }
                }

                BigActionButton(title: "Перейти в конструктор", subtitle: "Добавь упражнения и сохрани", icon: "arrow.right.circle.fill") {
                    programsViewModel.startCreateDraft(name: name, category: category, totalWeeks: totalWeeks)
                    router.push(.programBuilder)
                }

                SmallActionButton(title: "Назад", icon: "chevron.left") {
                    router.pop()
                }
            }
            .padding(16)
        }
        .navigationTitle("Новая программа")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProgramBuilderView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel

    @State private var errorMessage: String?
    @State private var savedProgram: CoachProgramListItem?

    var body: some View {
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
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
                            .background(Color.card)
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
                            .foregroundStyle(Color.textPrimary)

                            Stepper(
                                "Текущая неделя: \(programsViewModel.builderDraft.currentWeek)",
                                value: Binding(
                                    get: { programsViewModel.builderDraft.currentWeek },
                                    set: { programsViewModel.builderDraft.currentWeek = max(1, min($0, programsViewModel.builderDraft.totalWeeks)) }
                                ),
                                in: 1...24
                            )
                            .foregroundStyle(Color.textPrimary)

                            Stepper(
                                "Всего недель: \(programsViewModel.builderDraft.totalWeeks)",
                                value: Binding(
                                    get: { programsViewModel.builderDraft.totalWeeks },
                                    set: {
                                        programsViewModel.builderDraft.totalWeeks = max(1, $0)
                                        programsViewModel.builderDraft.currentWeek = min(programsViewModel.builderDraft.currentWeek, programsViewModel.builderDraft.totalWeeks)
                                    }
                                ),
                                in: 1...24
                            )
                            .foregroundStyle(Color.textPrimary)
                        }
                    }

                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("База упражнений")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.textPrimary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(MuscleGroup.allCases) { group in
                                        MuscleGroupChipButton(title: group.title, isSelected: programsViewModel.selectedMuscleGroup == group) {
                                            programsViewModel.selectedMuscleGroup = group
                                        }
                                        .frame(width: 96)
                                    }
                                }
                            }

                            ForEach(programsViewModel.filteredExercises) { exercise in
                                Button {
                                    programsViewModel.toggleExercise(exercise)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(exercise.name)
                                                .foregroundStyle(Color.textPrimary)
                                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            Text(exercise.equipment)
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundStyle(Color.textSecondary)
                                        }
                                        Spacer()
                                        Image(systemName: programsViewModel.builderDraft.exerciseIDs.contains(exercise.id) ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(programsViewModel.builderDraft.exerciseIDs.contains(exercise.id) ? Color.green : Color.textSecondary)
                                    }
                                    .padding(10)
                                    .background(Color.card)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }

                            Text("Выбрано упражнений: \(programsViewModel.builderDraft.exerciseIDs.count)")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.textSecondary)
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    BigActionButton(title: "Сохранить программу", subtitle: "Сохранить в библиотеку", icon: "tray.and.arrow.down.fill") {
                        switch programsViewModel.saveDraft() {
                        case .success(let program):
                            errorMessage = nil
                            savedProgram = program
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }

                    BigActionButton(title: "Отправить клиенту", subtitle: "Назначить программу подопечному", icon: "paperplane.fill") {
                        if savedProgram == nil {
                            switch programsViewModel.saveDraft() {
                            case .success(let program):
                                savedProgram = program
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }

                    SmallActionButton(title: "Назад", icon: "chevron.left") {
                        router.pop()
                    }
                }
                .padding(16)
            }
        }
        .onAppear {
            if programsViewModel.builderDraft == .empty {
                programsViewModel.startCreateDraft()
            }
            clientsViewModel.load()
        }
        .sheet(item: $savedProgram) { program in
            ProgramAssignSheet(program: program)
                .environmentObject(programsViewModel)
                .environmentObject(clientsViewModel)
        }
        .navigationTitle("Конструктор")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddWeekView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Добавить неделю", subtitle: "Количество тренировок • Фокус")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    SmallActionButton(title: "Назад", icon: "chevron.left") { router.pop() }
                }
                .padding(16)
            }
    }
}

struct AddWorkoutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Добавить тренировку", subtitle: "Название • Тип • Упражнения")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    SmallActionButton(title: "Назад", icon: "chevron.left") { router.pop() }
                }
                .padding(16)
            }
    }
}

struct WorkoutBuilderView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Конструктор тренировки", subtitle: "Добавление упражнений • Подходов • Повторений")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "База упражнений") { router.push(.exerciseLibrary) }
                        PrimaryButton(title: "Сохранить программу") { router.push(.saveProgram) }
                    }
                }
                .padding(16)
            }
    }
}

struct ExerciseLibraryView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel

    var body: some View {
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("База упражнений")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.textPrimary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(MuscleGroup.allCases) { group in
                                        MuscleGroupChipButton(title: group.title, isSelected: programsViewModel.selectedMuscleGroup == group) {
                                            programsViewModel.selectedMuscleGroup = group
                                        }
                                        .frame(width: 96)
                                    }
                                }
                            }

                            ForEach(programsViewModel.filteredExercises) { exercise in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(exercise.name)
                                            .foregroundStyle(Color.textPrimary)
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Text(exercise.equipment)
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundStyle(Color.textSecondary)
                                    }
                                    Spacer()
                                }
                                .padding(10)
                                .background(Color.card)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                        }
                    }

                    BigActionButton(title: "Открыть конструктор", subtitle: "Собери программу из базы", icon: "square.and.pencil") {
                        router.push(.programBuilder)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("База упражнений")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddExerciseToWorkoutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Добавить упражнение", subtitle: "Подходы • Повторения • Вес • Темп • Отдых")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    SmallActionButton(title: "Назад", icon: "chevron.left") { router.pop() }
                }
                .padding(16)
            }
    }
}

private struct ProgramAssignSheet: View {
    let program: CoachProgramListItem

    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(clientsViewModel.clients) { client in
                Button {
                    programsViewModel.assignProgram(programID: program.id, to: client)
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(client.name)
                            Text(client.email)
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)
                        }
                        Spacer()
                        Text(client.status.title)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
            .navigationTitle("Назначить: \(program.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}

private struct MetricTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct BigActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.brandPrimary)
                    .frame(width: 48, height: 48)
                    .background(Color.buttonPrimaryText.opacity(0.14))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.buttonPrimaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(subtitle)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.buttonPrimaryText.opacity(0.78))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.buttonPrimaryText.opacity(0.75))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color.buttonPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct SmallActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .lineLimit(2)
            .minimumScaleFactor(0.78)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.buttonPrimaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.buttonPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.border.opacity(0.6), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct MuscleGroupChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(isSelected ? Color.buttonPrimaryText : Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.buttonPrimary : Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.border.opacity(isSelected ? 0 : 1), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private extension View {
    func glassCardStyle() -> some View {
        self
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
    FlowCoordinatorView()
}
