import Foundation

enum AICoach {
    static func analyzeWorkout(workout: Workout) -> [String] {
        let totalSets = workout.exercises.reduce(0) { $0 + $1.sets.count }
        let totalReps = workout.exercises.flatMap { $0.sets }.reduce(0) { $0 + $1.reps }
        let avgWeight = averageWeight(for: workout)

        var recommendations: [String] = []

        if totalSets < 8 {
            recommendations.append("Добавь 1–2 подхода для объема")
        }

        if totalReps < 30 {
            recommendations.append("Увеличь суммарные повторения")
        }

        if avgWeight < 70 {
            recommendations.append("Постепенно увеличь рабочий вес")
        }

        if recommendations.isEmpty {
            recommendations.append("Отличная работа! Продолжай в том же духе")
        }

        return recommendations
    }

    static func analyzeProgress() -> [String] {
        let workouts = WorkoutStorage.load()

        guard workouts.count >= 3 else {
            return ["Недостаточно данных для анализа прогресса"]
        }

        let lastThree = workouts.suffix(3)
        let avgWeight = averageWeight(for: Array(lastThree))

        if avgWeight < 70 {
            return ["Увеличь рабочий вес", "Следи за прогрессией каждую неделю"]
        }

        return ["Прогресс хороший", "Сохраняй стабильный объем и интенсивность"]
    }

    private static func averageWeight(for workout: Workout) -> Double {
        let sets = workout.exercises.flatMap { $0.sets }
        guard !sets.isEmpty else { return 0 }
        let total = sets.reduce(0) { $0 + $1.weight }
        return total / Double(sets.count)
    }

    private static func averageWeight(for workouts: [Workout]) -> Double {
        let sets = workouts.flatMap { $0.exercises }.flatMap { $0.sets }
        guard !sets.isEmpty else { return 0 }
        let total = sets.reduce(0) { $0 + $1.weight }
        return total / Double(sets.count)
    }
}
