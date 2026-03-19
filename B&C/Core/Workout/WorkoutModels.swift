import Foundation

struct WorkoutSet: Codable, Identifiable, Hashable {
    let id: UUID
    var weight: Double
    var reps: Int

    init(id: UUID = UUID(), weight: Double, reps: Int) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }
}

struct Exercise: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var sets: [WorkoutSet]

    init(id: UUID = UUID(), name: String, sets: [WorkoutSet]) {
        self.id = id
        self.name = name
        self.sets = sets
    }
}

struct Workout: Codable, Identifiable, Hashable {
    let id: UUID
    var date: Date
    var exercises: [Exercise]

    init(id: UUID = UUID(), date: Date, exercises: [Exercise]) {
        self.id = id
        self.date = date
        self.exercises = exercises
    }
}
