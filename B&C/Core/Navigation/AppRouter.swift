import Combine

@MainActor
final class AppRouter: ObservableObject {
    enum UserRole: String, Hashable {
        case coach
        case athlete
    }

    @Published var path: [AppRoute] = []
    @Published var role: UserRole? = nil
    @Published var isAuthorized: Bool = false

    func resetToRoot() {
        path.removeAll()
        role = nil
        isAuthorized = false
    }

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func setRoleAndContinue(_ role: UserRole) {
        self.role = role
        switch role {
        case .coach:
            push(.coachOnboarding)
        case .athlete:
            push(.athleteOnboarding)
        }
    }

    func finishOnboarding() {
        isAuthorized = true
        guard let role else {
            push(.selectRole)
            return
        }
        switch role {
        case .coach:
            push(.coachTabBar)
        case .athlete:
            push(.athleteTabBar)
        }
    }

    func goToDashboard() {
        guard let role else {
            popToRoot()
            push(.login)
            return
        }
        popToRoot()
        switch role {
        case .coach:
            push(.coachTabBar)
        case .athlete:
            push(.athleteTabBar)
        }
    }
}

