import Combine
import Foundation

@MainActor
final class WorkoutViewModel: ObservableObject {
    @Published var currentProgram: WorkoutProgram = WorkoutProgram(
        name: "Базовая программа",
        exercises: [
            ExercisePlan(name: "Тяга блока", targetReps: 10, plannedWeight: 60),
            ExercisePlan(name: "Жим гантелей", targetReps: 10, plannedWeight: 20),
            ExercisePlan(name: "Тяга штанги", targetReps: 8, plannedWeight: 50)
        ]
    )
    @Published var currentExerciseIndex: Int = 0
    @Published var sessionExercises: [ExerciseSession] = []
    @Published var recommendations: [String] = []
    @Published var planUpdates: [String] = []

    init() {
        sessionExercises = currentProgram.exercises.map { ExerciseSession(name: $0.name, sets: []) }
    }

    var currentExerciseName: String {
        sessionExercises[safe: currentExerciseIndex]?.name ?? "Упражнение"
    }

    var currentSets: [WorkoutSet] {
        sessionExercises[safe: currentExerciseIndex]?.sets ?? []
    }

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
        guard sessionExercises.indices.contains(currentExerciseIndex) else { return }
        let newSet = WorkoutSet(weight: weight, reps: reps)
        sessionExercises[currentExerciseIndex].sets.append(newSet)
    }

    func nextExercise() -> Bool {
        let next = currentExerciseIndex + 1
        guard sessionExercises.indices.contains(next) else { return false }
        currentExerciseIndex = next
        return true
    }

    func finishWorkout() {
        let workout = Workout(
            date: Date(),
            exercises: sessionExercises
                .filter { !$0.sets.isEmpty }
                .map { Exercise(name: $0.name, sets: $0.sets) }
        )

        WorkoutStorage.save(workout: workout)
        recommendations = AICoach.analyzeWorkout(workout: workout)
        planUpdates = updateProgram(from: workout)
        sessionExercises = currentProgram.exercises.map { ExerciseSession(name: $0.name, sets: []) }
        currentExerciseIndex = 0
    }

    private func averageWeight(for workout: Workout) -> Double {
        let allSets = workout.exercises.flatMap { $0.sets }
        guard !allSets.isEmpty else { return 0 }
        let total = allSets.reduce(0) { $0 + $1.weight }
        return total / Double(allSets.count)
    }

    private func updateProgram(from workout: Workout) -> [String] {
        var updates: [String] = []

        for exercise in workout.exercises {
            guard let idx = currentProgram.exercises.firstIndex(where: { $0.name == exercise.name }) else { continue }
            guard let lastSet = exercise.sets.last else { continue }
            let target = currentProgram.exercises[idx].targetReps
            let current = currentProgram.exercises[idx].plannedWeight
            let nextWeight = AICoach.adjustWeight(current: current, reps: lastSet.reps, target: target)
            if nextWeight != current {
                currentProgram.exercises[idx].plannedWeight = nextWeight
                updates.append("Обновлен план для \(exercise.name): \(Int(current)) → \(Int(nextWeight)) кг")
            }
        }

        return updates.isEmpty ? ["План без изменений"] : updates
    }
}

struct WorkoutSummaryItem: Identifiable {
    let id = UUID()
    let date: Date
    let averageWeight: Double
    let totalSets: Int
}

struct WorkoutProgram {
    var name: String
    var exercises: [ExercisePlan]
}

struct ExercisePlan {
    var name: String
    var targetReps: Int
    var plannedWeight: Double
}

struct ExerciseSession {
    var name: String
    var sets: [WorkoutSet]
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
