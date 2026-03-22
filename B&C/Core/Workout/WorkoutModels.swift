import Foundation

struct WorkoutSet: Codable, Hashable {
    var weight: Double
    var reps: Int
}

struct Exercise: Codable, Hashable {
    var name: String
    var sets: [WorkoutSet]
}

struct Workout: Codable, Hashable {
    var date: Date
    var exercises: [Exercise]
}
