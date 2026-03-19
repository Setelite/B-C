import SwiftUI

struct LoginScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Login Screen", subtitle: "Authentication Module")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Login") { router.push(.selectRole) }
                        PrimaryButton(title: "Go to Registration") { router.push(.registration) }
                        PrimaryButton(title: "Debug menu") { router.push(.debugMenu) }
                    }
                }
                .padding(16)
            }
    }
}

struct RegistrationScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Registration Screen", subtitle: "Authentication Module")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Create account") { router.push(.selectRole) }
                        PrimaryButton(title: "Back to Login") { router.popToRoot() }
                    }
                }
                .padding(16)
            }
    }
}

struct SelectUserRoleView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Select User Role", subtitle: "Coach / Athlete")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "I'm a Coach") { router.setRoleAndContinue(.coach) }
                        PrimaryButton(title: "I'm an Athlete") { router.setRoleAndContinue(.athlete) }
                    }
                }
                .padding(16)
            }
    }
}

struct CoachOnboardingView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Coach Onboarding", subtitle: "Coach flow")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    PrimaryButton(title: "Finish onboarding") { router.finishOnboarding() }
                }
                .padding(16)
            }
    }
}

struct AthleteOnboardingView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(title: "Athlete Onboarding", subtitle: "Athlete flow")
            .safeAreaInset(edge: .bottom) {
                CardView {
                    PrimaryButton(title: "Finish onboarding") { router.finishOnboarding() }
                }
                .padding(16)
            }
    }
}

#Preview {
    FlowCoordinatorView()
}
