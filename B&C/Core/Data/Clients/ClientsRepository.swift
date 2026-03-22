import Foundation

protocol ClientsRepository {
    func fetchClients() -> [ClientListItem]
    func saveClients(_ clients: [ClientListItem])
}

struct UserDefaultsClientsRepository: ClientsRepository {
    private let key = "coach_clients"

    func fetchClients() -> [ClientListItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ClientListItem].self, from: data) else {
            let seeded = seedClients()
            saveClients(seeded)
            return seeded
        }
        return decoded
    }

    func saveClients(_ clients: [ClientListItem]) {
        guard let data = try? JSONEncoder().encode(clients) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func seedClients() -> [ClientListItem] {
        [
            ClientListItem(name: "Алексей Петров", email: "alexey@example.com", status: .active, progress: 78, lastActivity: Date().addingTimeInterval(-60 * 45)),
            ClientListItem(name: "Ирина Смирнова", email: "irina@example.com", status: .active, progress: 64, lastActivity: Date().addingTimeInterval(-60 * 60 * 14)),
            ClientListItem(name: "Николай Воронов", email: "nikolay@example.com", status: .paused, progress: 41, lastActivity: Date().addingTimeInterval(-60 * 60 * 72)),
            ClientListItem(name: "Марина Ковалева", email: "marina@example.com", status: .new, progress: 12, lastActivity: Date().addingTimeInterval(-60 * 60 * 2))
        ]
    }
}
