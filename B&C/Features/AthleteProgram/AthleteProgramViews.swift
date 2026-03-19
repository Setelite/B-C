import SwiftUI

struct MyProgramView2: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "My Program",
            subtitle: "Календарь тренировок • План на неделю"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Workout Calendar") { router.push(.workoutCalendar) }
                    PrimaryButton(title: "Workout Detail") { router.push(.workoutDetailFromCalendar) }
                    PrimaryButton(title: "Empty State: No Program") { router.push(.emptyStateNoProgram) }
                }
            }
            .padding(16)
        }
    }
}

struct WorkoutCalendarView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Workout Calendar",
            subtitle: "Прошлые • Текущие • Будущие"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Выбрать тренировку") { router.push(.workoutDetailFromCalendar) }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}

