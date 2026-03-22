import SwiftUI

struct CoachTabBarView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var selection: Int = 0
    
    init() {
        TabBarAppearance.configure()
    }
    
    var body: some View {
        TabView(
            selection: Binding(
                get: { selection },
                set: { newValue in
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        selection = newValue
                    }
                }
            )
        ) {
            CoachHomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            
            ClientsListScreenView()
                .tabItem { Label("Clients", systemImage: "person.2.fill") }
                .tag(1)
            
            ProgramsLibraryView()
                .tabItem { Label("Programs", systemImage: "square.grid.2x2.fill") }
                .tag(2)
            
            ChatListView()
                .tabItem { Label("Messages", systemImage: "bubble.left.and.bubble.right.fill") }
                .tag(3)
            
            CoachProfileView2()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                .tag(4)
        }
        .tint(.brandPrimary)
        .toolbar(.visible, for: .tabBar)
        .toolbarBackground(.hidden, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .onAppear {
            TabBarAppearance.configure()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                    router.resetToRoot()
                }
            }
        }
    }
    
    #Preview {
        FlowCoordinatorView()
    }
}
