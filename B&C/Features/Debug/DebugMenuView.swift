import SwiftUI

struct DebugMenuView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Debug Menu")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Login") {
                            router.popToRoot()
                            router.push(.login)
                        }

                        PrimaryButton(title: "Coach TabBar") {
                            router.popToRoot()
                            router.role = .coach
                            router.isAuthorized = true
                            router.push(.coachTabBar)
                        }

                        PrimaryButton(title: "Athlete TabBar") {
                            router.popToRoot()
                            router.role = .athlete
                            router.isAuthorized = true
                            router.push(.athleteTabBar)
                        }
                    }
                }

                CardView {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Design Gallery") {
                            router.push(.designGallery)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.bgPrimary)
        .navigationTitle("Debug")
    }
}

#Preview {
    FlowCoordinatorView()
}

