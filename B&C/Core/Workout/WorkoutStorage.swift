import Foundation

final class WorkoutStorage {
    private static let key = "workouts"
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    static func save(workout: Workout) {
        var workouts = load()
        workouts.append(workout)
        persist(workouts)
    }

    static func load() -> [Workout] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? decoder.decode([Workout].self, from: data)) ?? []
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    private static func persist(_ workouts: [Workout]) {
        guard let data = try? encoder.encode(workouts) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
