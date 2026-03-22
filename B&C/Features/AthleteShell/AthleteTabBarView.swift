import SwiftUI

struct AthleteTabBarView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            AthleteHomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            MyProgramView2()
                .tabItem { Label("My Program", systemImage: "calendar") }
                .tag(1)

            ExerciseProgressView()
                .tabItem { Label("Exercise", systemImage: "chart.xyaxis.line") }
                .tag(2)

            ProgressDashboardView()
                .tabItem { Label("Progress", systemImage: "waveform.path.ecg") }
                .tag(3)

            CoachChatView()
                .tabItem { Label("Messages", systemImage: "bubble.left") }
                .tag(4)

            AthleteProfileView2()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(5)
        }
        .tint(.brandPrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                    router.resetToRoot()
                }
            }
        }
    }
}

#Preview {
    FlowCoordinatorView()
}
