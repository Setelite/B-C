import Foundation

struct RevenueEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var amount: Int

    init(id: UUID = UUID(), date: Date, amount: Int) {
        self.id = id
        self.date = date
        self.amount = amount
    }
}

protocol RevenueRepository {
    func fetchEntries() -> [RevenueEntry]
    func saveEntries(_ entries: [RevenueEntry])
}

struct UserDefaultsRevenueRepository: RevenueRepository {
    private let key = "coach_revenue_entries"

    func fetchEntries() -> [RevenueEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([RevenueEntry].self, from: data) else {
            let seeded = seedEntries()
            saveEntries(seeded)
            return seeded
        }
        return decoded
    }

    func saveEntries(_ entries: [RevenueEntry]) {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func seedEntries() -> [RevenueEntry] {
        var entries: [RevenueEntry] = []
        let calendar = Calendar.current
        let now = Date()

        for dayOffset in 0..<420 {
            guard let dayDate = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            let count = 1 + ((dayOffset * 13) % 3)
            let base = 3_000 + ((dayOffset * 37) % 5_000)

            for index in 0..<count {
                let hour = 8 + ((dayOffset * 7 + index * 3) % 12)
                let minute = (dayOffset * 11 + index * 17) % 60
                let amount = base + (index * 1_800) + ((dayOffset * 29) % 2_500)

                if let timestamp = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dayDate) {
                    entries.append(RevenueEntry(date: timestamp, amount: amount))
                }
            }
        }

        return entries.sorted(by: { $0.date < $1.date })
    }
}
