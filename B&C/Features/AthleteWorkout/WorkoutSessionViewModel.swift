import Combine
import Foundation

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var currentExerciseName: String = "Тяга блока"
    @Published var sets: [WorkoutSet] = []
    @Published var recommendations: [String] = []

    var progressHistory: [WorkoutSummaryItem] {
        WorkoutStorage.load()
            .suffix(5)
            .reversed()
            .map { workout in
                WorkoutSummaryItem(
                    date: workout.date,
                    averageWeight: averageWeight(for: workout),
                    totalSets: workout.exercises.reduce(0) { $0 + $1.sets.count }
                )
            }
    }

    func logSet(weight: Double, reps: Int) {
        let newSet = WorkoutSet(weight: weight, reps: reps)
        sets.append(newSet)
    }

    func finishWorkout() {
        let workout = Workout(
            date: Date(),
            exercises: [
                Exercise(name: currentExerciseName, sets: sets)
            ]
        )

        WorkoutStorage.save(workout: workout)
        recommendations = AICoach.analyzeWorkout(workout: workout)
        sets = []
    }

    private func averageWeight(for workout: Workout) -> Double {
        let allSets = workout.exercises.flatMap { $0.sets }
        guard !allSets.isEmpty else { return 0 }
        let total = allSets.reduce(0) { $0 + $1.weight }
        return total / Double(allSets.count)
    }
}

struct WorkoutSummaryItem: Identifiable {
    let id = UUID()
    let date: Date
    let averageWeight: Double
    let totalSets: Int
}
