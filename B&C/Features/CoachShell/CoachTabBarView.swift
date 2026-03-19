import SwiftUI

struct CoachTabBarView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            CoachHomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            ClientsListScreenView()
                .tabItem { Label("Clients", systemImage: "person.2") }
                .tag(1)

            ProgramsLibraryView()
                .tabItem { Label("Programs", systemImage: "square.grid.2x2") }
                .tag(2)

            ChatListView()
                .tabItem { Label("Messages", systemImage: "bubble.left.and.bubble.right") }
                .tag(3)

            CoachProfileView2()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(4)
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
