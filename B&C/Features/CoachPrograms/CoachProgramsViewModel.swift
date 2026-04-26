import Combine
import Foundation
import SwiftUI

enum CoachProgramCategory: String, CaseIterable, Codable, Identifiable {
    case strength
    case hypertrophy
    case endurance
    case fatLoss
    case mobility

    var id: String { rawValue }

    var title: String {
        switch self {
        case .strength: return "Силовые"
        case .hypertrophy: return "Гипертрофия"
        case .endurance: return "Выносливость"
        case .fatLoss: return "Жиросжигание"
        case .mobility: return "Мобилити"
        }
    }

    var iconName: String {
        switch self {
        case .strength: return "figure.strengthtraining.traditional"
        case .hypertrophy: return "dumbbell.fill"
        case .endurance: return "figure.run"
        case .fatLoss: return "bolt.heart.fill"
        case .mobility: return "figure.yoga"
        }
    }

    var tint: Color {
        switch self {
        case .strength: return .brandPrimary
        case .hypertrophy: return .green
        case .endurance: return .blue
        case .fatLoss: return .orange
        case .mobility: return .mint
        }
    }
}

struct CoachProgramListItem: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var category: CoachProgramCategory
    var assignedClients: Int
    var currentWeek: Int
    var totalWeeks: Int

    init(
        id: UUID = UUID(),
        name: String,
        category: CoachProgramCategory,
        assignedClients: Int,
        currentWeek: Int,
        totalWeeks: Int
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.assignedClients = assignedClients
        self.currentWeek = currentWeek
        self.totalWeeks = totalWeeks
    }

    var phaseText: String {
        "W\(currentWeek)/\(max(totalWeeks, 1))"
    }

    var completionRate: Int {
        let clampedWeek = max(0, min(currentWeek, max(totalWeeks, 1)))
        return Int((Double(clampedWeek) / Double(max(totalWeeks, 1))) * 100)
    }
}

struct ProgramCategoryMetric: Identifiable {
    let id = UUID()
    let category: CoachProgramCategory
    let count: Int
}

enum MuscleGroup: String, CaseIterable, Identifiable {
    case chest
    case back
    case legs
    case shoulders
    case arms
    case core
    case cardio

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chest: return "Грудь"
        case .back: return "Спина"
        case .legs: return "Ноги"
        case .shoulders: return "Плечи"
        case .arms: return "Руки"
        case .core: return "Кор"
        case .cardio: return "Кардио"
        }
    }
}

struct ExerciseLibraryItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let group: MuscleGroup
    let equipment: String

    init(id: UUID = UUID(), name: String, group: MuscleGroup, equipment: String) {
        self.id = id
        self.name = name
        self.group = group
        self.equipment = equipment
    }
}

struct ProgramBuilderDraft: Equatable {
    var sourceProgramID: UUID?
    var name: String
    var category: CoachProgramCategory
    var assignedClients: Int
    var currentWeek: Int
    var totalWeeks: Int
    var exerciseIDs: [UUID]

    static let empty = ProgramBuilderDraft(
        sourceProgramID: nil,
        name: "",
        category: .strength,
        assignedClients: 0,
        currentWeek: 1,
        totalWeeks: 8,
        exerciseIDs: []
    )
}

enum ProgramDraftError: LocalizedError {
    case emptyName
    case invalidWeeks
    case invalidCurrentWeek
    case invalidAssignedClients

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Введите название программы."
        case .invalidWeeks:
            return "Длительность должна быть больше 0."
        case .invalidCurrentWeek:
            return "Текущая неделя должна быть в пределах плана."
        case .invalidAssignedClients:
            return "Количество клиентов не может быть отрицательным."
        }
    }
}

@MainActor
final class CoachProgramsViewModel: ObservableObject {
    @Published private(set) var programs: [CoachProgramListItem] = []
    @Published private(set) var lastUpdated: Date = Date()
    @Published var builderDraft: ProgramBuilderDraft = .empty
    @Published var selectedMuscleGroup: MuscleGroup = .chest

    private let repository: any ProgramsRepository

    init(repository: any ProgramsRepository) {
        self.repository = repository
        load()
    }

    convenience init() {
        self.init(repository: UserDefaultsProgramsRepository())
    }

    func load() {
        programs = repository.fetchPrograms().sorted { $0.assignedClients > $1.assignedClients }
        lastUpdated = Date()
    }

    var totalPrograms: Int {
        programs.count
    }

    var totalAssignedClients: Int {
        programs.reduce(0) { $0 + $1.assignedClients }
    }

    var averageProgramCompletion: Int {
        guard !programs.isEmpty else { return 0 }
        return programs.map(\.completionRate).reduce(0, +) / programs.count
    }

    var categoryMetrics: [ProgramCategoryMetric] {
        CoachProgramCategory.allCases.compactMap { category in
            let count = programs.filter { $0.category == category }.count
            return count > 0 ? ProgramCategoryMetric(category: category, count: count) : nil
        }
    }

    var topPrograms: [CoachProgramListItem] {
        Array(programs.prefix(5))
    }

    var exerciseLibrary: [ExerciseLibraryItem] {
        [
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Жим штанги лежа", group: .chest, equipment: "Штанга"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "Жим гантелей под углом", group: .chest, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, name: "Сведения в кроссовере", group: .chest, equipment: "Блочный"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000019")!, name: "Отжимания на брусьях", group: .chest, equipment: "Собственный вес"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000020")!, name: "Отжимания с паузой", group: .chest, equipment: "Собственный вес"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, name: "Тяга верхнего блока", group: .back, equipment: "Блочный"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, name: "Тяга штанги в наклоне", group: .back, equipment: "Штанга"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, name: "Горизонтальная тяга", group: .back, equipment: "Тренажер"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000021")!, name: "Подтягивания широким хватом", group: .back, equipment: "Турник"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000022")!, name: "Тяга Т-грифа", group: .back, equipment: "Тренажер"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, name: "Присед со штангой", group: .legs, equipment: "Штанга"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, name: "Жим ногами", group: .legs, equipment: "Тренажер"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, name: "Румынская тяга", group: .legs, equipment: "Штанга"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000023")!, name: "Выпады с гантелями", group: .legs, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000024")!, name: "Сгибание ног лежа", group: .legs, equipment: "Тренажер"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!, name: "Жим гантелей сидя", group: .shoulders, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000011")!, name: "Махи в стороны", group: .shoulders, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000012")!, name: "Тяга к подбородку", group: .shoulders, equipment: "Штанга"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000025")!, name: "Разведения в наклоне", group: .shoulders, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000013")!, name: "Сгибания на бицепс", group: .arms, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000014")!, name: "Французский жим", group: .arms, equipment: "EZ-гриф"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000015")!, name: "Разгибания на блоке", group: .arms, equipment: "Блочный"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000026")!, name: "Молотки стоя", group: .arms, equipment: "Гантели"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000027")!, name: "Отжимания узким хватом", group: .arms, equipment: "Собственный вес"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000016")!, name: "Планка", group: .core, equipment: "Собственный вес"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000017")!, name: "Скручивания", group: .core, equipment: "Собственный вес"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000018")!, name: "Подъем ног в висе", group: .core, equipment: "Турник"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000028")!, name: "Русский твист", group: .core, equipment: "Медбол"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000029")!, name: "Беговая дорожка (интервалы)", group: .cardio, equipment: "Кардио"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000030")!, name: "Эллипс (LISS)", group: .cardio, equipment: "Кардио"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000031")!, name: "Велотренажер (спринты)", group: .cardio, equipment: "Кардио"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000032")!, name: "Гребной тренажер", group: .cardio, equipment: "Кардио"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000033")!, name: "Скакалка интервальная", group: .cardio, equipment: "Собственный вес"),
            ExerciseLibraryItem(id: UUID(uuidString: "00000000-0000-0000-0000-000000000034")!, name: "Ходьба в горку", group: .cardio, equipment: "Беговая дорожка")
        ]
    }

    var filteredExercises: [ExerciseLibraryItem] {
        exerciseLibrary.filter { $0.group == selectedMuscleGroup }
    }

    var selectedExercises: [ExerciseLibraryItem] {
        exerciseLibrary.filter { builderDraft.exerciseIDs.contains($0.id) }
    }

    func startCreateDraft(name: String = "", category: CoachProgramCategory = .strength, totalWeeks: Int = 8) {
        builderDraft = ProgramBuilderDraft(
            sourceProgramID: nil,
            name: name,
            category: category,
            assignedClients: 0,
            currentWeek: 1,
            totalWeeks: max(1, totalWeeks),
            exerciseIDs: []
        )
    }

    func startEditDraft(programID: UUID) {
        guard let program = programs.first(where: { $0.id == programID }) else { return }
        builderDraft = ProgramBuilderDraft(
            sourceProgramID: program.id,
            name: program.name,
            category: program.category,
            assignedClients: program.assignedClients,
            currentWeek: max(1, program.currentWeek),
            totalWeeks: max(1, program.totalWeeks),
            exerciseIDs: []
        )
    }

    func toggleExercise(_ exercise: ExerciseLibraryItem) {
        if builderDraft.exerciseIDs.contains(exercise.id) {
            builderDraft.exerciseIDs.removeAll { $0 == exercise.id }
        } else {
            builderDraft.exerciseIDs.append(exercise.id)
        }
    }

    func assignProgram(programID: UUID, to client: ClientListItem) {
        guard let index = programs.firstIndex(where: { $0.id == programID }) else { return }
        programs[index].assignedClients += 1
        persist()
    }

    func saveDraft() -> Result<CoachProgramListItem, ProgramDraftError> {
        let cleanName = builderDraft.name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { return .failure(.emptyName) }
        guard builderDraft.totalWeeks > 0 else { return .failure(.invalidWeeks) }
        guard builderDraft.currentWeek > 0 && builderDraft.currentWeek <= builderDraft.totalWeeks else {
            return .failure(.invalidCurrentWeek)
        }
        guard builderDraft.assignedClients >= 0 else { return .failure(.invalidAssignedClients) }

        if let sourceProgramID = builderDraft.sourceProgramID,
           let index = programs.firstIndex(where: { $0.id == sourceProgramID }) {
            programs[index].name = cleanName
            programs[index].category = builderDraft.category
            programs[index].assignedClients = builderDraft.assignedClients
            programs[index].currentWeek = builderDraft.currentWeek
            programs[index].totalWeeks = builderDraft.totalWeeks
            persist()
            return .success(programs[index])
        }

        let program = CoachProgramListItem(
            name: cleanName,
            category: builderDraft.category,
            assignedClients: builderDraft.assignedClients,
            currentWeek: builderDraft.currentWeek,
            totalWeeks: builderDraft.totalWeeks
        )
        programs.insert(program, at: 0)
        persist()
        builderDraft = .empty
        return .success(program)
    }

    private func persist() {
        programs.sort { $0.assignedClients > $1.assignedClients }
        repository.savePrograms(programs)
        lastUpdated = Date()
    }
}
