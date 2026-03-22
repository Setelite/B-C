import SwiftUI

struct CoachHomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel
    @EnvironmentObject private var programsViewModel: CoachProgramsViewModel

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

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    CoachHeaderView(
                        onOpenClients: { router.push(.clientsList) },
                        onOpenPrograms: { router.push(.programsLibrary) },
                        onOpenAnalytics: { router.push(.progressAnalytics) }
                    )
                    ClientsOverviewSection(clients: clientsViewModel.clients)
                    ProgramsOverviewSection(
                        programs: programsViewModel.programs,
                        categoryMetrics: programsViewModel.categoryMetrics,
                        totalAssignedClients: programsViewModel.totalAssignedClients,
                        averageProgramCompletion: programsViewModel.averageProgramCompletion
                    )
                    AnalyticsOverviewSection(clients: clientsViewModel.clients)
                }
                .padding(16)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            clientsViewModel.load()
            programsViewModel.load()
        }
    }
}

private struct CoachHeaderView: View {
    let onOpenClients: () -> Void
    let onOpenPrograms: () -> Void
    let onOpenAnalytics: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Body&Code")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))

                    Text("Панель тренера")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

                Spacer()

                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .clipShape(Circle())
            }

            HStack(spacing: 8) {
                CompactActionButton(title: "Клиенты", icon: "person.2.fill", action: onOpenClients)
                CompactActionButton(title: "Программы", icon: "square.grid.2x2.fill", action: onOpenPrograms)
                CompactActionButton(title: "Аналитика", icon: "waveform.path.ecg", action: onOpenAnalytics)
            }
        }
    }
}

private struct ClientsOverviewSection: View {
    let clients: [ClientListItem]

    private var activeCount: Int { clients.filter { $0.status == .active }.count }
    private var pausedCount: Int { clients.filter { $0.status == .paused }.count }
    private var newCount: Int { clients.filter { $0.status == .new }.count }
    private var avgProgress: Int {
        guard !clients.isEmpty else { return 0 }
        return Int(clients.map(\.progress).reduce(0, +) / clients.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Сводка по клиентам", subtitle: "График статусов и таблица активности")

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Активные")
                    Spacer()
                    Text("\(activeCount)")
                }
                HStack {
                    Text("Пауза")
                    Spacer()
                    Text("\(pausedCount)")
                }
                HStack {
                    Text("Новые")
                    Spacer()
                    Text("\(newCount)")
                }
            }
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.white.opacity(0.76))

            StackedShareBar(values: [
                (label: "Активные", value: activeCount, color: .green),
                (label: "Пауза", value: pausedCount, color: .orange),
                (label: "Новые", value: newCount, color: .brandPrimary)
            ])

            DashboardTableCard(
                headers: ["Клиент", "Статус", "Прогресс"],
                rows: clients.sorted(by: { $0.lastActivity > $1.lastActivity }).prefix(4).map {
                    [
                        $0.name,
                        $0.status.title,
                        "\($0.progress)%"
                    ]
                },
                emptyTitle: "Клиентов пока нет"
            )

            HStack(spacing: 8) {
                MetricPill(title: "Всего", value: "\(clients.count)")
                MetricPill(title: "Средний прогресс", value: "\(avgProgress)%")
            }
        }
        .glassCardStyle()
    }
}

private struct ProgramsOverviewSection: View {
    let programs: [CoachProgramListItem]
    let categoryMetrics: [ProgramCategoryMetric]
    let totalAssignedClients: Int
    let averageProgramCompletion: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Программы", subtitle: "Библиотека и конструктор в виде графики и таблицы")

            HStack(spacing: 10) {
                ForEach(Array(categoryMetrics.prefix(4))) { metric in
                    ProgramIconNode(
                        icon: metric.category.iconName,
                        title: metric.category.title,
                        tint: metric.category.tint,
                        count: metric.count
                    )
                }
            }

            ProgramDistributionBars(programs: programs)

            DashboardTableCard(
                headers: ["Программа", "Клиенты", "Фаза"],
                rows: programs.prefix(5).map { ["\($0.name)", "\($0.assignedClients)", "\($0.phaseText)"] },
                emptyTitle: "Библиотека программ пуста"
            )

            HStack(spacing: 8) {
                MetricPill(title: "Назначено клиентам", value: "\(totalAssignedClients)")
                MetricPill(title: "Среднее выполнение", value: "\(averageProgramCompletion)%")
            }
        }
        .glassCardStyle()
    }
}

private struct AnalyticsOverviewSection: View {
    let clients: [ClientListItem]

    private var trendData: [Int] {
        let sorted = clients.sorted(by: { $0.lastActivity < $1.lastActivity })
        let values = sorted.prefix(8).map(\.progress)
        if values.count >= 4 { return values }
        return [34, 41, 49, 57, 63, 66, 71, 74]
    }

    private var aiRecommendations: [[String]] {
        let progress = trendData.last ?? 0
        if progress < 50 {
            return [
                ["Низкий adherence", "Добавить 1 лёгкую сессию", "Высокий"],
                ["Падение темпа", "Снизить объём на 15%", "Средний"]
            ]
        }
        return [
            ["Рост по тренду", "Увеличить рабочий вес +2.5кг", "Высокий"],
            ["Стабильный recovery", "Оставить текущий объём", "Низкий"]
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Аналитика", subtitle: "Тренды, рекомендации, корректировки")

            SparklineCard(values: trendData)

            DashboardTableCard(
                headers: ["Сигнал", "Рекомендация", "Приоритет"],
                rows: aiRecommendations,
                emptyTitle: "Недостаточно данных для аналитики"
            )

            HStack(spacing: 8) {
                MetricPill(title: "Корректировок", value: "\(aiRecommendations.count)")
                MetricPill(title: "Тренд", value: trendData.last ?? 0 >= (trendData.first ?? 0) ? "Рост" : "Снижение")
            }
        }
        .glassCardStyle()
    }
}

private struct CompactActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

private struct MetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.65))
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct StackedShareBar: View {
    let values: [(label: String, value: Int, color: Color)]

    private var total: Int {
        max(values.reduce(0) { $0 + $1.value }, 1)
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(values.enumerated()), id: \.offset) { _, item in
                Rectangle()
                    .fill(item.color.opacity(0.9))
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                    .mask(
                        GeometryReader { geo in
                            Rectangle()
                                .frame(width: geo.size.width * CGFloat(item.value) / CGFloat(total), alignment: .leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                )
            }
        }
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}

private struct DashboardTableCard: View {
    let headers: [String]
    let rows: [[String]]
    let emptyTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ForEach(headers, id: \.self) { header in
                    Text(header)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.06))

            if rows.isEmpty {
                Text(emptyTitle)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            } else {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    HStack {
                        ForEach(row.indices, id: \.self) { index in
                            Text(row[index])
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)

                    if row != rows.last {
                        Divider().overlay(Color.white.opacity(0.09))
                    }
                }
            }
        }
        .background(Color.white.opacity(0.04))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ProgramIconNode: View {
    let icon: String
    let title: String
    let tint: Color
    let count: Int

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 34, height: 34)
                .background(tint.opacity(0.14))
                .overlay(
                    Circle().stroke(tint.opacity(0.24), lineWidth: 1)
                )
                .clipShape(Circle())
            Text(title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.84))
                .lineLimit(1)
            Text("\(count)")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProgramDistributionBars: View {
    let programs: [CoachProgramListItem]

    private var maxClients: Double {
        Double(programs.map(\.assignedClients).max() ?? 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ForEach(programs) { item in
                HStack(spacing: 8) {
                    Text(item.name)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))
                        .frame(width: 86, alignment: .leading)

                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(Color.brandPrimary.opacity(0.9))
                                    .frame(width: geo.size.width * CGFloat(Double(item.assignedClients) / maxClients))
                            }
                    }
                    .frame(height: 8)

                    Text("\(item.assignedClients)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 24, alignment: .trailing)
                }
            }
        }
    }
}

private struct SparklineCard: View {
    let values: [Int]

    private var normalized: [CGFloat] {
        guard let minValue = values.min(),
              let maxValue = values.max(),
              maxValue != minValue
        else {
            return values.map { _ in 0.5 }
        }
        let range = CGFloat(maxValue - minValue)
        return values.map { CGFloat($0 - minValue) / range }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Тренд прогресса")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.72))
                Spacer()
                Text("\(values.last ?? 0)%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }

            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let step = width / CGFloat(max(values.count - 1, 1))

                Path { path in
                    for (index, point) in normalized.enumerated() {
                        let x = CGFloat(index) * step
                        let y = (1 - point) * height
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.brandPrimary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            }
            .frame(height: 56)
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
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

private extension View {
    func glassCardStyle() -> some View {
        modifier(GlassCardModifier())
    }
}

private struct NoiseOverlay: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let dotCount = 2400
                var rng = SeededGenerator(seed: 99)
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

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1
        return state
    }
}

#Preview {
    FlowCoordinatorView()
}
