import SwiftUI

struct AssignProgramView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Assign Program",
            subtitle: "Назначить программу клиенту • Выбор из библиотеки или создание новой"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Select Program") { router.push(.selectProgram) }
                    PrimaryButton(title: "Create Program (Screen)") { router.push(.createProgramScreen) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}

