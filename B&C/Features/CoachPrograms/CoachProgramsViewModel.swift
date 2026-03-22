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

struct ProgramBuilderDraft: Equatable {
    var sourceProgramID: UUID?
    var name: String
    var category: CoachProgramCategory
    var assignedClients: Int
    var currentWeek: Int
    var totalWeeks: Int

    static let empty = ProgramBuilderDraft(
        sourceProgramID: nil,
        name: "",
        category: .strength,
        assignedClients: 0,
        currentWeek: 1,
        totalWeeks: 8
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

    func startCreateDraft(name: String = "", category: CoachProgramCategory = .strength, totalWeeks: Int = 8) {
        builderDraft = ProgramBuilderDraft(
            sourceProgramID: nil,
            name: name,
            category: category,
            assignedClients: 0,
            currentWeek: 1,
            totalWeeks: max(1, totalWeeks)
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
            totalWeeks: max(1, program.totalWeeks)
        )
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
