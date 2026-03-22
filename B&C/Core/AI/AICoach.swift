import Foundation

final class AICoach {
    static func adjustWeight(current: Double, reps: Int, target: Int) -> Double {
        if reps > target {
            return current + 2.5
        } else if reps < target {
            return max(0, current - 2.5)
        } else {
            return current
        }
    }

    static func analyzeWorkout(workout: Workout) -> [String] {
        var recommendations: [String] = []

        for exercise in workout.exercises {
            for set in exercise.sets {
                if set.reps < 8 {
                    recommendations.append("Снизь вес в \(exercise.name)")
                } else if set.reps > 12 {
                    recommendations.append("Увеличь вес в \(exercise.name)")
                }
            }
        }

        return recommendations.isEmpty ? ["Отличная работа! Продолжай в том же духе"] : recommendations
    }

    static func analyzeProgress() -> [String] {
        let workouts = WorkoutStorage.load()

        guard workouts.count > 3 else {
            return ["Недостаточно данных"]
        }

        let last = workouts.suffix(3)
        var avgWeight: Double = 0
        var count = 0

        for workout in last {
            for ex in workout.exercises {
                for set in ex.sets {
                    avgWeight += set.weight
                    count += 1
                }
            }
        }

        guard count > 0 else {
            return ["Недостаточно данных"]
        }

        avgWeight /= Double(count)

        if avgWeight < 70 {
            return ["Увеличь рабочий вес"]
        } else {
            return ["Прогресс хороший 🔥"]
        }
    }
}
