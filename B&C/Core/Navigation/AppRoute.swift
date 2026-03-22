import Foundation

enum AppRoute: Hashable {
    // MARK: - Auth Flow
    case login
    case registration
    case selectRole
    case coachOnboarding
    case athleteOnboarding

    // MARK: - Main shells
    case coachTabBar
    case athleteTabBar

    // MARK: - Coach: Clients / Assign Program
    case clients
    case clientsList
    case addClient
    case invitationSent
    case emptyStateNoClients
    case clientDetail
    case viewClientProgress
    case coachProgressView
    case openClientChat
    case assignProgram
    case selectProgram
    case configureAssignment
    case confirmAssignment
    case pushNotificationAthleteProgramAssigned
    case backendCreateProgramCopy

    // MARK: - Coach: Programs / Builder
    case programs
    case programsLibrary
    case emptyStateNoPrograms
    case programMarketplace
    case createProgramScreen
    case programBuilder
    case addWeek
    case addWorkout
    case workoutBuilder
    case exerciseLibrary
    case addExerciseToWorkout
    case saveProgram
    case errorSaveFailed

    // MARK: - Coach: Messages
    case messages
    case chatList
    case emptyStateNoMessages
    case chatDetail
    case sendMessage
    case shareWorkout
    case shareProgress
    case messageSent
    case errorMessageFailed
    case pushNotificationNewMessage

    // MARK: - Coach: Home / Analytics / Settings
    case coachHome
    case progressAnalytics
    case aiInsights
    case profileSettings
    case businessSettings
    case coachProfile
    case coachStatistics
    case communityAndSocial

    // MARK: - Athlete: Home / Workout
    case athleteHome
    case todaysWorkout
    case startWorkoutScreen
    case workoutView
    case workoutDetail
    case exerciseExecution
    case logSet
    case nextExercise
    case completeWorkout
    case workoutSummary
    case saveWorkoutData
    case pushNotificationCoachWorkoutCompleted
    case offlineMode
    case noInternet

    // MARK: - Athlete: My Program / Calendar
    case myProgram
    case workoutCalendar
    case workoutDetailFromCalendar
    case emptyStateNoProgram
    case waitingAssignmentEmptyState

    // MARK: - Athlete: Progress / Metrics
    case exerciseProgress
    case progress
    case progressDashboard
    case metricsHistory
    case logMetrics
    case saveMetrics
    case backendRecalculateProgress
    case backendUpdateTrends
    case aiCoachAssistant

    // MARK: - Athlete: Messages / Settings / Profile
    case athleteMessages
    case coachChat
    case athleteSettings
    case goalsSettings
    case athleteProfile
    case bodyMetrics

    // MARK: - Design / Debug
    case designGallery
    case debugMenu
}
