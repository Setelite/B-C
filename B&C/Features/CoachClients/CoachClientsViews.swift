import SwiftUI

struct ClientsListScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var viewModel: CoachClientsListViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.bgPrimary, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.brandPrimary.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 40)
                .offset(x: 140, y: -260)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 28)
                .offset(x: -160, y: 220)

            ClientsNoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Clients List Screen")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Список всех клиентов • Статус • Прогресс • Последняя активность")
                        .font(.system(size: 15, weight: .regular, design: .serif))
                        .foregroundStyle(.white.opacity(0.72))

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.55))
                        TextField("Поиск клиента", text: $viewModel.query)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.14), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.metrics) { metric in
                                ClientsMetricCard(metric: metric)
                            }
                        }
                    }

                    HStack(spacing: 8) {
                        ForEach(ClientStatus.allCases, id: \.self) { status in
                            Button {
                                viewModel.selectedFilter = status
                            } label: {
                                Text(status.title)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(viewModel.selectedFilter == status ? .white : .white.opacity(0.75))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(viewModel.selectedFilter == status ? Color.brandPrimary : Color.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(Color.white.opacity(viewModel.selectedFilter == status ? 0.0 : 0.14), lineWidth: 1)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if viewModel.filteredClients.isEmpty {
                        ClientsGlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Клиенты не найдены")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)

                                Text("Измени фильтр или добавь нового клиента.")
                                    .font(.system(size: 14, weight: .regular, design: .serif))
                                    .foregroundStyle(.white.opacity(0.72))

                                PrimaryButton(title: "Add Client") { router.push(.addClient) }
                                PrimaryButton(title: "Empty State: No Clients") { router.push(.emptyStateNoClients) }
                            }
                        }
                    } else {
                        ForEach(viewModel.filteredClients) { item in
                            ClientsGlassCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text(item.status.badge)
                                            .font(.system(size: 11, weight: .bold, design: .rounded))
                                            .foregroundStyle(item.status.badgeColor)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 8)
                                            .background(item.status.badgeColor.opacity(0.16))
                                            .clipShape(Capsule())
                                    }

                                    HStack {
                                        Text("Прогресс")
                                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.8))
                                        Spacer()
                                        Text("\(item.progress)%")
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(.white)
                                    }

                                    ProgressView(value: Double(item.progress) / 100.0)
                                        .tint(item.status.badgeColor)

                                    Text("Последняя активность: \(viewModel.formattedLastActivity(for: item))")
                                        .font(.system(size: 13, weight: .regular, design: .serif))
                                        .foregroundStyle(.white.opacity(0.72))

                                    HStack(spacing: 10) {
                                        PrimaryButton(title: "Open Client Detail") {
                                            viewModel.selectClient(item)
                                            router.push(.clientDetail)
                                        }
                                        Button {
                                            viewModel.selectClient(item)
                                            router.push(.openClientChat)
                                        } label: {
                                            Image(systemName: "message.fill")
                                                .foregroundStyle(.white)
                                                .frame(width: 46, height: 46)
                                                .background(Color.white.opacity(0.08))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }

                    ClientsGlassCard {
                        VStack(spacing: 12) {
                            PrimaryButton(title: "Add Client") { router.push(.addClient) }
                            PrimaryButton(title: "Empty State: No Clients") { router.push(.emptyStateNoClients) }
                        }
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Clients")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ClientsGlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct ClientsMetricCard: View {
    let metric: ClientMetricCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(metric.title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))

            Text("\(metric.value)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(metric.tint)
        }
        .padding(12)
        .frame(width: 110, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ClientsNoiseOverlay: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let dotCount = 2200
                var rng = ClientsSeededGenerator(seed: 120)
                for _ in 0..<dotCount {
                    let x = CGFloat.random(in: 0...size.width, using: &rng)
                    let y = CGFloat.random(in: 0...size.height, using: &rng)
                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(.white.opacity(0.08)))
                }
            }
            .blur(radius: 0.6)
        }
        .allowsHitTesting(false)
    }
}

private struct ClientsSeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1
        return state
    }
}

struct AddClientScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var validationMessage: String?

    var body: some View {
        AppScreen(
            title: "Add Client Screen",
            subtitle: "Email приглашение или создание • Отправить приглашение"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    TextField("Имя клиента", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    if let validationMessage {
                        Text(validationMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    PrimaryButton(title: "Send invitation") {
                        switch clientsViewModel.addClient(name: name, email: email) {
                        case .success(let created):
                            clientsViewModel.selectClient(created)
                            validationMessage = nil
                            name = ""
                            email = ""
                            router.push(.invitationSent)
                        case .failure(let error):
                            validationMessage = error.localizedDescription
                        }
                    }
                }
            }
            .padding(16)
        }
    }
}

struct InvitationSentView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Invitation Sent",
            subtitle: "Backend: создание invite token • Email/SMS отправка"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Back to Clients") { router.goToDashboard() }
            }
            .padding(16)
        }
    }
}

struct ClientDetailScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.bgPrimary, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    let client = clientsViewModel.selectedClient

                    Text(client?.name ?? "Client Detail Screen")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(client.map { "\($0.email) • \($0.status.title)" } ?? "Программы • Прогресс • Метрики • История")
                        .font(.system(size: 15, weight: .regular, design: .serif))
                        .foregroundStyle(.white.opacity(0.72))

                    ClientsGlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Текущий прогресс")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.85))
                            Text("\(client?.progress ?? 0)%")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(client?.status.badgeColor ?? .white)
                            ProgressView(value: Double(client?.progress ?? 0) / 100.0)
                                .tint(client?.status.badgeColor ?? .brandPrimary)
                        }
                    }

                    ClientsGlassCard {
                        VStack(spacing: 12) {
                            PrimaryButton(title: "Assign Program") { router.push(.assignProgram) }
                            PrimaryButton(title: "View Client Progress") { router.push(.viewClientProgress) }
                            PrimaryButton(title: "Open Client Chat") { router.push(.openClientChat) }
                        }
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Client")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewClientProgressView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "View Client Progress",
            subtitle: "Графики • Метрики • Выполненные тренировки"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Coach Progress View") { router.push(.coachProgressView) }
                    PrimaryButton(title: "Progress Analytics") { router.push(.progressAnalytics) }
                    PrimaryButton(title: "Share Progress") { router.push(.progressAnalytics) }
                }
            }
            .padding(16)
        }
    }
}

struct CoachProgressView: View {
    var body: some View {
        AppScreen(
            title: "Coach Progress View",
            subtitle: "Все метрики • Тренировки • Сравнения"
        )
    }
}
