import Combine
import Foundation
import SwiftUI

enum ClientStatus: String, CaseIterable, Identifiable, Codable {
    case all
    case active
    case paused
    case new

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "Все"
        case .active: return "Активные"
        case .paused: return "Пауза"
        case .new: return "Новые"
        }
    }

    var badge: String {
        switch self {
        case .all: return "ALL"
        case .active: return "ACTIVE"
        case .paused: return "PAUSED"
        case .new: return "NEW"
        }
    }

    var badgeColor: Color {
        switch self {
        case .all: return .white
        case .active: return .green
        case .paused: return .orange
        case .new: return .brandPrimary
        }
    }
}

struct ClientListItem: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var email: String
    var status: ClientStatus
    var progress: Int
    var lastActivity: Date

    init(id: UUID = UUID(), name: String, email: String, status: ClientStatus, progress: Int, lastActivity: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.status = status
        self.progress = progress
        self.lastActivity = lastActivity
    }
}

struct ClientMetricCardModel: Identifiable {
    let id = UUID()
    let title: String
    let value: Int
    let tint: Color
}

enum AddClientValidationError: LocalizedError {
    case emptyName
    case emptyEmail
    case invalidEmail
    case duplicateEmail

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Введите имя клиента."
        case .emptyEmail:
            return "Введите email клиента."
        case .invalidEmail:
            return "Проверьте формат email."
        case .duplicateEmail:
            return "Клиент с таким email уже существует."
        }
    }
}

@MainActor
final class CoachClientsListViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var selectedFilter: ClientStatus = .all
    @Published private(set) var clients: [ClientListItem] = []
    @Published private(set) var lastUpdated: Date = Date()
    @Published private(set) var selectedClientID: UUID?

    private let repository: any ClientsRepository
    private let relativeDateFormatter = RelativeDateTimeFormatter()

    init(repository: any ClientsRepository = UserDefaultsClientsRepository()) {
        self.repository = repository
        relativeDateFormatter.locale = Locale(identifier: "ru_RU")
        relativeDateFormatter.unitsStyle = .short
        load()
    }

    func load() {
        clients = repository.fetchClients()
        lastUpdated = Date()
    }

    func selectClient(_ client: ClientListItem) {
        selectedClientID = client.id
    }

    var selectedClient: ClientListItem? {
        guard let selectedClientID else { return nil }
        return clients.first(where: { $0.id == selectedClientID })
    }

    func addClient(name: String, email: String) -> Result<ClientListItem, AddClientValidationError> {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return .failure(.emptyName) }
        guard !cleanEmail.isEmpty else { return .failure(.emptyEmail) }
        guard Self.isValidEmail(cleanEmail) else { return .failure(.invalidEmail) }
        guard !clients.contains(where: { $0.email.caseInsensitiveCompare(cleanEmail) == .orderedSame }) else {
            return .failure(.duplicateEmail)
        }

        let newClient = ClientListItem(
            name: cleanName,
            email: cleanEmail,
            status: .new,
            progress: 0,
            lastActivity: Date()
        )

        clients.insert(newClient, at: 0)
        persist()
        return .success(newClient)
    }

    var filteredClients: [ClientListItem] {
        clients
            .filter { item in
                let matchFilter = selectedFilter == .all || item.status == selectedFilter
                let matchQuery = query.isEmpty || item.name.localizedCaseInsensitiveContains(query) || item.email.localizedCaseInsensitiveContains(query)
                return matchFilter && matchQuery
            }
            .sorted { $0.lastActivity > $1.lastActivity }
    }

    var metrics: [ClientMetricCardModel] {
        [
            ClientMetricCardModel(title: "Всего", value: clients.count, tint: .white),
            ClientMetricCardModel(title: "Активные", value: clients.filter { $0.status == .active }.count, tint: .green),
            ClientMetricCardModel(title: "Пауза", value: clients.filter { $0.status == .paused }.count, tint: .orange),
            ClientMetricCardModel(title: "Новые", value: clients.filter { $0.status == .new }.count, tint: .brandPrimary)
        ]
    }

    func formattedLastActivity(for item: ClientListItem) -> String {
        relativeDateFormatter.localizedString(for: item.lastActivity, relativeTo: Date())
    }

    private func persist() {
        repository.saveClients(clients)
        lastUpdated = Date()
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
