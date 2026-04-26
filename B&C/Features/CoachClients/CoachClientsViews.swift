import SwiftUI

struct ClientsListScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var viewModel: CoachClientsListViewModel

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Клиенты")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                        Text("Статус, прогресс, активность и быстрые действия")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.textSecondary)
                    }

                    searchBar

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.metrics) { metric in
                                ClientsMetricCard(metric: metric)
                            }
                        }
                        .padding(.vertical, 2)
                    }

                    statusFilters

                    if viewModel.filteredClients.isEmpty {
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Клиенты не найдены")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.textPrimary)
                                Text("Измени фильтр, строку поиска или добавь нового клиента")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.textSecondary)
                                PrimaryButton(title: "Добавить клиента") { router.push(.addClient) }
                            }
                        }
                    } else {
                        ForEach(viewModel.filteredClients) { item in
                            clientCard(item)
                        }
                    }

                    PrimaryButton(title: "Добавить клиента") {
                        router.push(.addClient)
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle("Клиенты")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.load()
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.textSecondary)

            TextField("Поиск клиента", text: $viewModel.query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .tint(Color.brandPrimary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var statusFilters: some View {
        HStack(spacing: 8) {
            ForEach(ClientStatus.allCases, id: \.self) { status in
                Button {
                    viewModel.selectedFilter = status
                } label: {
                    Text(status.title)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(viewModel.selectedFilter == status ? Color.buttonPrimaryText : Color.textPrimary)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedFilter == status ? Color.buttonPrimary : Color.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.border.opacity(viewModel.selectedFilter == status ? 0 : 1), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func clientCard(_ item: ClientListItem) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Text(item.email)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }

                    Spacer()

                    Text(item.status.title)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(statusTextColor(item.status))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(statusBgColor(item.status))
                        .clipShape(Capsule())
                }

                HStack {
                    Text("Прогресс")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                    Spacer()
                    Text("\(item.progress)%")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                }

                ProgressView(value: Double(item.progress) / 100.0)
                    .tint(Color.brandPrimary)

                Text("Последняя активность: \(viewModel.formattedLastActivity(for: item))")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)

                HStack(spacing: 10) {
                    buttonPill(title: "Профиль", icon: "person.text.rectangle") {
                        viewModel.selectClient(item)
                        router.push(.clientDetail)
                    }
                    buttonPill(title: "Чат", icon: "message") {
                        viewModel.selectClient(item)
                        router.push(.openClientChat)
                    }
                }
            }
        }
    }

    private func buttonPill(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(Color.buttonPrimaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.buttonPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func statusTextColor(_ status: ClientStatus) -> Color {
        switch status {
        case .all: return Color.textPrimary
        case .active: return Color.green
        case .paused: return Color.orange
        case .new: return Color.brandPrimary
        }
    }

    private func statusBgColor(_ status: ClientStatus) -> Color {
        switch status {
        case .all: return Color.border.opacity(0.55)
        case .active: return Color.green.opacity(0.15)
        case .paused: return Color.orange.opacity(0.15)
        case .new: return Color.brandPrimary.opacity(0.15)
        }
    }
}

private struct ClientsMetricCard: View {
    let metric: ClientMetricCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)
            Text("\(metric.value)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(metric.tint == .white ? Color.textPrimary : metric.tint)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(14)
        .frame(width: 146, alignment: .leading)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct AddClientScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var validationMessage: String?

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Новый клиент")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)

                    CardView {
                        VStack(spacing: 12) {
                            TextField("Имя клиента", text: $name)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(Color.bgPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 14)
                                .background(Color.bgPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                            if let validationMessage {
                                Text(validationMessage)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            PrimaryButton(title: "Отправить приглашение") {
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
                }
                .padding(18)
            }
        }
        .navigationTitle("Добавить клиента")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InvitationSentView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Приглашение отправлено",
            subtitle: "Клиент получит письмо и появится в списке после подтверждения"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Назад к клиентам") { router.goToDashboard() }
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
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    let client = clientsViewModel.selectedClient

                    Text(client?.name ?? "Клиент")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)

                    Text(client.map { "\($0.email) • \($0.status.title)" } ?? "Программы, прогресс и активность")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)

                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Текущий прогресс")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.textSecondary)
                            Text("\(client?.progress ?? 0)%")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.textPrimary)
                            ProgressView(value: Double(client?.progress ?? 0) / 100.0)
                                .tint(Color.brandPrimary)
                        }
                    }

                    CardView {
                        VStack(spacing: 12) {
                            PrimaryButton(title: "Назначить программу") { router.push(.assignProgram) }
                            PrimaryButton(title: "Прогресс клиента") { router.push(.viewClientProgress) }
                            PrimaryButton(title: "Открыть чат") { router.push(.openClientChat) }
                        }
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewClientProgressView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Прогресс клиента",
            subtitle: "Графики, метрики и история выполненных тренировок"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Обзор прогресса") { router.push(.coachProgressView) }
                    PrimaryButton(title: "Аналитика") { router.push(.progressAnalytics) }
                    PrimaryButton(title: "Поделиться прогрессом") { router.push(.progressAnalytics) }
                }
            }
            .padding(16)
        }
    }
}

struct CoachProgressView: View {
    var body: some View {
        AppScreen(
            title: "Аналитика прогресса",
            subtitle: "Все метрики, тренировки и сравнение по периодам"
        )
    }
}
