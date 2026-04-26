import SwiftUI

struct CoachHomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var clientsViewModel: CoachClientsListViewModel

    var body: some View {
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    CoachHeaderView(
                        onOpenClients: { router.push(.clientsList) },
                        onOpenPrograms: { router.push(.programsLibrary) },
                        onOpenAnalytics: { router.push(.progressAnalytics) }
                    )
                    RevenueOverviewSection()
                    ClientsOverviewSection(clients: clientsViewModel.clients)
                    AnalyticsOverviewSection(clients: clientsViewModel.clients)
                }
                .padding(16)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            clientsViewModel.load()
        }
    }
}

private struct RevenueOverviewSection: View {
    @State private var selectedRange: RevenueRange = .month
    @State private var entries: [RevenueEntry] = []
    private let repository: any RevenueRepository = UserDefaultsRevenueRepository()

    private var buckets: [RevenueBucket] {
        if entries.isEmpty {
            return fallbackBuckets
        }

        switch selectedRange {
        case .day:
            return makeDayBuckets()
        case .week:
            return makeWeekBuckets()
        case .month:
            return makeMonthBuckets()
        case .year:
            return makeYearBuckets()
        }
    }

    private var chartValues: [Int] {
        buckets.map(\.value)
    }

    private var chartLabels: [String] {
        buckets.map(\.label)
    }

    private var total: Int {
        chartValues.reduce(0, +)
    }

    private var currentValue: Int {
        chartValues.last ?? 0
    }

    private var previousValue: Int {
        chartValues.dropLast().last ?? 0
    }

    private var growthPercent: Int {
        guard previousValue > 0 else { return 0 }
        return Int(((Double(currentValue) - Double(previousValue)) / Double(previousValue)) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Доход", subtitle: "Выберите период и смотрите динамику")

            HStack(spacing: 8) {
                ForEach(RevenueRange.allCases, id: \.self) { range in
                    RevenueRangeButton(
                        title: range.title,
                        isSelected: selectedRange == range
                    ) {
                        selectedRange = range
                    }
                }
            }

            RevenueCurveChart(values: chartValues, labels: chartLabels)

            HStack(spacing: 8) {
                MetricPill(title: selectedRange.metricTitle, value: "\(currentValue.formattedRubles)")
                MetricPill(title: "Рост к прошлому", value: "\(growthPercent >= 0 ? "+" : "")\(growthPercent)%")
                MetricPill(title: "Итого", value: "\(total.formattedRubles)")
            }
        }
        .glassCardStyle()
        .onAppear {
            entries = repository.fetchEntries()
        }
    }

    private var fallbackBuckets: [RevenueBucket] {
        [
            RevenueBucket(label: "-", value: 0),
            RevenueBucket(label: "-", value: 0)
        ]
    }

    private func makeDayBuckets() -> [RevenueBucket] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"

        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let snappedHour = currentHour - (currentHour % 3)
        let endSlot = calendar.date(bySettingHour: snappedHour, minute: 0, second: 0, of: now) ?? now

        return (0..<7).map { offset in
            let slotStart = calendar.date(byAdding: .hour, value: -3 * (6 - offset), to: endSlot) ?? endSlot
            let slotEnd = calendar.date(byAdding: .hour, value: 3, to: slotStart) ?? slotStart
            let amount = entries
                .filter { $0.date >= slotStart && $0.date < slotEnd }
                .reduce(0) { $0 + $1.amount }
            return RevenueBucket(label: formatter.string(from: slotStart), value: amount)
        }
    }

    private func makeWeekBuckets() -> [RevenueBucket] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EE"

        let today = calendar.startOfDay(for: Date())
        return (0..<7).map { offset in
            let day = calendar.date(byAdding: .day, value: -(6 - offset), to: today) ?? today
            let nextDay = calendar.date(byAdding: .day, value: 1, to: day) ?? day
            let amount = entries
                .filter { $0.date >= day && $0.date < nextDay }
                .reduce(0) { $0 + $1.amount }
            return RevenueBucket(label: formatter.string(from: day).capitalized, value: amount)
        }
    }

    private func makeMonthBuckets() -> [RevenueBucket] {
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) ?? today
        let daysRange = calendar.range(of: .day, in: .month, for: today) ?? 1..<31
        let totalDays = daysRange.count
        let segmentLength = max(1, Int(ceil(Double(totalDays) / 5.0)))

        return (0..<5).map { index in
            let startDay = 1 + index * segmentLength
            let endDay = min(totalDays, startDay + segmentLength - 1)
            let bucketStart = calendar.date(byAdding: .day, value: startDay - 1, to: startOfMonth) ?? startOfMonth
            let bucketEnd = calendar.date(byAdding: .day, value: endDay, to: startOfMonth) ?? bucketStart
            let amount = entries
                .filter { $0.date >= bucketStart && $0.date < bucketEnd }
                .reduce(0) { $0 + $1.amount }
            return RevenueBucket(label: "\(startDay)-\(endDay)", value: amount)
        }
    }

    private func makeYearBuckets() -> [RevenueBucket] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMM"

        let today = Date()
        let currentMonthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) ?? today

        return (0..<6).map { index in
            let periodStart = calendar.date(byAdding: .month, value: -(10 - index * 2), to: currentMonthStart) ?? currentMonthStart
            let periodEnd = calendar.date(byAdding: .month, value: 2, to: periodStart) ?? periodStart
            let amount = entries
                .filter { $0.date >= periodStart && $0.date < periodEnd }
                .reduce(0) { $0 + $1.amount }
            let startLabel = formatter.string(from: periodStart).capitalized
            let endMonth = calendar.date(byAdding: .month, value: 1, to: periodStart) ?? periodStart
            let endLabel = formatter.string(from: endMonth).capitalized
            return RevenueBucket(label: "\(startLabel)-\(endLabel)", value: amount)
        }
    }
}

private enum RevenueRange: CaseIterable {
    case day
    case week
    case month
    case year

    var title: String {
        switch self {
        case .day: return "День"
        case .week: return "Неделя"
        case .month: return "Месяц"
        case .year: return "Год"
        }
    }

    var metricTitle: String {
        switch self {
        case .day: return "Текущий день"
        case .week: return "Текущая неделя"
        case .month: return "Текущий месяц"
        case .year: return "Текущий год"
        }
    }
}

private struct RevenueRangeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(isSelected ? Color.buttonPrimaryText : Color.textPrimary)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.buttonPrimary : Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.border.opacity(isSelected ? 0 : 1), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct RevenueBucket {
    let label: String
    let value: Int
}

private enum ClientProgressRange: CaseIterable {
    case day
    case week
    case month
    case year

    var title: String {
        switch self {
        case .day: return "День"
        case .week: return "Неделя"
        case .month: return "Месяц"
        case .year: return "Год"
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
                        .foregroundColor(Color.textSecondary)

                    Text("Панель тренера")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                         .foregroundColor(Color.textPrimary)
                }

                Spacer()

                Image(systemName: "chart.bar.doc.horizontal.fill")
                     .foregroundColor(Color.textPrimary)
                    .padding(10)
                    .background(Color.card)
                    .overlay(
                        Circle().stroke(Color.border, lineWidth: 1)
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
    @State private var selectedRange: ClientProgressRange = .week

    private var activeCount: Int { clients.filter { $0.status == .active }.count }
    private var pausedCount: Int { clients.filter { $0.status == .paused }.count }
    private var newCount: Int { clients.filter { $0.status == .new }.count }
    private var avgProgress: Int {
        guard !clients.isEmpty else { return 0 }
        return Int(clients.map(\.progress).reduce(0, +) / clients.count)
    }

    private var trendValues: [Int] {
        let base = max(35, avgProgress)
        switch selectedRange {
        case .day:
            return buildSeries(base: base, count: 12, step: 2)
        case .week:
            return buildSeries(base: base, count: 14, step: 3)
        case .month:
            return buildSeries(base: base, count: 16, step: 2)
        case .year:
            return buildSeries(base: base, count: 12, step: 4)
        }
    }

    private var trendLabels: [String] {
        switch selectedRange {
        case .day:
            return ["08", "10", "12", "14", "16", "18", "20"]
        case .week:
            return ["Пн", "Ср", "Пт", "Вс"]
        case .month:
            return ["1", "8", "15", "22", "30"]
        case .year:
            return ["Янв", "Мар", "Май", "Июл", "Сен", "Ноя"]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Сводка по клиентам", subtitle: "Кривая прогресса и таблица активности")

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
            .lineLimit(1)
            .foregroundStyle(Color.textSecondary)

            HStack(spacing: 8) {
                ForEach(ClientProgressRange.allCases, id: \.self) { range in
                    RevenueRangeButton(
                        title: range.title,
                        isSelected: selectedRange == range
                    ) {
                        selectedRange = range
                    }
                }
            }

            ClientsCurveCard(values: trendValues, labels: trendLabels)

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

    private func buildSeries(base: Int, count: Int, step: Int) -> [Int] {
        guard count > 0 else { return [] }
        return (0..<count).map { index in
            let wave = Int((Double((index * 37) % 19) - 9.0) * 0.5)
            let trend = (index / step)
            return max(10, min(100, base - 8 + trend + wave))
        }
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

private struct RevenueCurveChart: View {
    let values: [Int]
    let labels: [String]

    private var normalized: [CGFloat] {
        guard let minValue = values.min(),
              let maxValue = values.max(),
              maxValue != minValue else {
            return values.map { _ in 0.5 }
        }
        let range = CGFloat(maxValue - minValue)
        return values.map { CGFloat($0 - minValue) / range }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Выручка")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                Text((values.last ?? 0).formattedRubles)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                     .foregroundStyle(Color.textPrimary)
            }

            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let step = width / CGFloat(max(values.count - 1, 1))

                ZStack {
                    Path { path in
                        for (index, point) in normalized.enumerated() {
                            let x = CGFloat(index) * step
                            let y = (1 - point) * height
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                let prevX = CGFloat(index - 1) * step
                                let prevY = (1 - normalized[index - 1]) * height
                                let controlX = (prevX + x) / 2
                                path.addCurve(
                                    to: CGPoint(x: x, y: y),
                                    control1: CGPoint(x: controlX, y: prevY),
                                    control2: CGPoint(x: controlX, y: y)
                                )
                            }
                        }
                    }
                    .stroke(Color.brandPrimary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))

                    Path { path in
                        guard !normalized.isEmpty else { return }
                        path.move(to: CGPoint(x: 0, y: height))
                        for (index, point) in normalized.enumerated() {
                            let x = CGFloat(index) * step
                            let y = (1 - point) * height
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.closeSubpath()
                    }
                    .fill(
                        Color.brandPrimary.opacity(0.12)
                    )
                }
            }
            .frame(height: 110)

            HStack {
                ForEach(labels.indices, id: \.self) { index in
                    Text(labels[index])
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(10)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
                    .foregroundStyle(Color.brandPrimary)
                Text(title)
            }
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .foregroundStyle(Color.buttonPrimaryText)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.buttonPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.border.opacity(0.6), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private extension Int {
    var formattedRubles: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let number = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(number) ₽"
    }
}

private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                 .foregroundStyle(Color.textPrimary)
            Text(subtitle)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
    }
}

private struct MetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                 .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct ClientsCurveCard: View {
    let values: [Int]
    let labels: [String]

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
                Text("Кривая прогресса клиентов")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                Text("\(values.last ?? 0)%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                     .foregroundStyle(Color.textPrimary)
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
                .stroke(Color.green, style: StrokeStyle(lineWidth: 2.3, lineCap: .round, lineJoin: .round))
            }
            .frame(height: 64)

            HStack {
                ForEach(labels.indices, id: \.self) { index in
                    Text(labels[index])
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(10)
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
        .background(Color.card)
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
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.card)

            if rows.isEmpty {
                    Text(emptyTitle)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            } else {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    HStack {
                        ForEach(row.indices, id: \.self) { index in
                            Text(row[index])
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                 .foregroundStyle(Color.textPrimary)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)

                    if row != rows.last {
                        Divider().overlay(Color.border)
                    }
                }
            }
        }
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
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
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
            Text("\(count)")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textSecondary)
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
                        .foregroundStyle(Color.textSecondary)
                        .frame(width: 86, alignment: .leading)

                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.card)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(Color.brandPrimary.opacity(0.9))
                                    .frame(width: geo.size.width * CGFloat(Double(item.assignedClients) / maxClients))
                            }
                    }
                    .frame(height: 8)

                    Text("\(item.assignedClients)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                         .foregroundStyle(Color.textPrimary)
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
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                Text("\(values.last ?? 0)%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                     .foregroundStyle(Color.textPrimary)
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
        .background(Color.card)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.card)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
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
