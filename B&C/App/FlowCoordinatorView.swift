import SwiftUI

struct FlowCoordinatorView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var workoutSession = WorkoutSessionViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            LoginScreenView()
                .environmentObject(router)
                .environmentObject(workoutSession)
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                        .environmentObject(router)
                        .environmentObject(workoutSession)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .login:
            LoginScreenView()
        case .registration:
            RegistrationScreenView()
        case .selectRole:
            SelectUserRoleView()
        case .coachOnboarding:
            CoachOnboardingView()
        case .athleteOnboarding:
            AthleteOnboardingView()

        case .coachTabBar:
            CoachTabBarView()
        case .athleteTabBar:
            AthleteTabBarView()

        // Coach
        case .coachHome:
            CoachHomeView()
        case .clients, .clientsList:
            ClientsListScreenView()
        case .addClient:
            AddClientScreenView()
        case .invitationSent:
            InvitationSentView()
        case .emptyStateNoClients:
            EmptyStateView(title: "Empty State: No Clients", subtitle: "Приглашение или добавление первого клиента")
        case .clientDetail:
            ClientDetailScreenView()
        case .viewClientProgress:
            ViewClientProgressView()
        case .coachProgressView:
            CoachProgressView()
        case .openClientChat, .chatDetail:
            ChatDetailView()
        case .assignProgram:
            AssignProgramView()
        case .selectProgram:
            SelectProgramView()
        case .configureAssignment:
            ConfigureAssignmentView()
        case .confirmAssignment:
            ConfirmAssignmentView()
        case .pushNotificationAthleteProgramAssigned:
            PushNotificationView(title: "Push Notification", subtitle: "Новая программа назначена")
        case .backendCreateProgramCopy:
            BackendStepView(title: "Backend: Create Program Copy", subtitle: "Создание копии программы • Привязка к клиенту • Уведомление")

        case .programs, .programsLibrary:
            ProgramsLibraryView()
        case .emptyStateNoPrograms:
            EmptyStateView(title: "Empty State: No Programs", subtitle: "Создание первой программы")
        case .programMarketplace:
            BackendStepView(title: "Program Marketplace", subtitle: "Покупка/продажа шаблонов (Future)")
        case .createProgramScreen:
            CreateProgramScreenView()
        case .programBuilder:
            ProgramBuilderView()
        case .addWeek:
            AddWeekView()
        case .addWorkout:
            AddWorkoutView()
        case .workoutBuilder:
            WorkoutBuilderView()
        case .exerciseLibrary:
            ExerciseLibraryView()
        case .addExerciseToWorkout:
            AddExerciseToWorkoutView()
        case .saveProgram:
            BackendStepView(title: "Save Program", subtitle: "Backend: сохранение структуры • Валидация данных")
        case .errorSaveFailed:
            ErrorView(title: "Error: Save Failed", subtitle: "Повтор или сохранение локально")

        case .messages, .chatList:
            ChatListView()
        case .emptyStateNoMessages:
            EmptyStateView(title: "Empty State: No Messages", subtitle: "Начните общение с клиентом")
        case .sendMessage:
            SendMessageView()
        case .shareWorkout:
            BackendStepView(title: "Share Workout", subtitle: "Отправка ссылки на тренировку")
        case .shareProgress:
            BackendStepView(title: "Share Progress", subtitle: "Графики, фото, сравнения")
        case .messageSent:
            BackendStepView(title: "Message Sent", subtitle: "Backend: сохранение сообщения • Push уведомление получателю")
        case .errorMessageFailed:
            ErrorView(title: "Error: Message Failed", subtitle: "Повторная отправка")
        case .pushNotificationNewMessage:
            PushNotificationView(title: "Push Notification", subtitle: "Уведомление о сообщении")

        case .progressAnalytics:
            ProgressAnalyticsView()
        case .aiInsights:
            AIInsightsView()
        case .profileSettings:
            ProfileSettingsView()
        case .businessSettings:
            BusinessSettingsView()
        case .coachProfile:
            CoachProfileView2()
        case .coachStatistics:
            CoachStatisticsView()
        case .communityAndSocial:
            CommunityAndSocialView()

        // Athlete
        case .athleteHome:
            AthleteHomeView()
        case .todaysWorkout:
            TodaysWorkoutView()
        case .startWorkoutScreen:
            StartWorkoutScreenView()
        case .workoutDetail, .workoutDetailFromCalendar:
            WorkoutDetailView()
        case .exerciseExecution:
            ExerciseExecutionView()
        case .logSet:
            LogSetView()
        case .nextExercise:
            NextExerciseView()
        case .completeWorkout:
            CompleteWorkoutV2View()
        case .workoutSummary:
            WorkoutSummaryView()
        case .saveWorkoutData:
            BackendStepView(title: "Save Workout Data", subtitle: "Backend: сохранение результатов • Обновление прогресса • Уведомление тренеру")
        case .pushNotificationCoachWorkoutCompleted:
            PushNotificationView(title: "Push Notification", subtitle: "Клиент завершил тренировку")
        case .offlineMode:
            OfflineModeView()
        case .noInternet:
            ErrorView(title: "Нет интернета", subtitle: "Offline Mode • Синхронизация позже")

        case .myProgram:
            MyProgramView2()
        case .workoutCalendar:
            WorkoutCalendarView()
        case .emptyStateNoProgram, .waitingAssignmentEmptyState:
            EmptyStateView(title: "Empty State: No Program", subtitle: "Ожидание назначения от тренера")

        case .exerciseProgress:
            ExerciseProgressView()
        case .progress:
            ProgressView2()
        case .progressDashboard:
            ProgressDashboardView()
        case .metricsHistory:
            MetricsHistoryView()
        case .logMetrics:
            LogMetricsView()
        case .saveMetrics:
            BackendStepView(title: "Save Metrics", subtitle: "Backend: сохранение метрик • Обновление графиков")
        case .backendRecalculateProgress:
            BackendStepView(title: "Backend: Recalculate Progress", subtitle: "Пересчет прогресса • Обновление графиков")
        case .backendUpdateTrends:
            BackendStepView(title: "Backend: Update Trends", subtitle: "Обновление трендов • Анализ изменений метрик")
        case .aiCoachAssistant:
            BackendStepView(title: "AI Coach Assistant", subtitle: "Автоматические советы и корректировки (Future)")

        case .athleteMessages:
            ChatListView()
        case .coachChat:
            CoachChatView()
        case .athleteSettings:
            AthleteSettingsView()
        case .goalsSettings:
            GoalsSettingsView()
        case .athleteProfile:
            AthleteProfileView2()
        case .bodyMetrics:
            BodyMetricsView()

        // Design / Debug
        case .designGallery:
            DesignGalleryView()
        case .debugMenu:
            DebugMenuView()
        }
    }
}

#Preview {
    FlowCoordinatorView()
}
