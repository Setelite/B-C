import Foundation

protocol ProgramsRepository {
    func fetchPrograms() -> [CoachProgramListItem]
    func savePrograms(_ programs: [CoachProgramListItem])
}

struct UserDefaultsProgramsRepository: ProgramsRepository {
    private let key = "coach_programs"

    func fetchPrograms() -> [CoachProgramListItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([CoachProgramListItem].self, from: data) else {
            let seeded = seedPrograms()
            savePrograms(seeded)
            return seeded
        }
        return decoded
    }

    func savePrograms(_ programs: [CoachProgramListItem]) {
        guard let data = try? JSONEncoder().encode(programs) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func seedPrograms() -> [CoachProgramListItem] {
        [
            CoachProgramListItem(name: "Base Strength", category: .strength, assignedClients: 12, currentWeek: 3, totalWeeks: 8),
            CoachProgramListItem(name: "Lean Cut", category: .fatLoss, assignedClients: 8, currentWeek: 2, totalWeeks: 6),
            CoachProgramListItem(name: "Hypertrophy Pro", category: .hypertrophy, assignedClients: 14, currentWeek: 5, totalWeeks: 10),
            CoachProgramListItem(name: "Endurance 5K", category: .endurance, assignedClients: 6, currentWeek: 4, totalWeeks: 8),
            CoachProgramListItem(name: "Mobility Reset", category: .mobility, assignedClients: 5, currentWeek: 1, totalWeeks: 4)
        ]
    }
}
