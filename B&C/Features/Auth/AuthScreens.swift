import SwiftUI

struct LoginScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
    }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AuthHeader(
                        title: "Вход",
                        subtitle: "Управляйте тренировками, клиентами и AI-рекомендациями в одном приложении"
                    )

                    CardView {
                        VStack(spacing: 14) {
                            AuthTextField(
                                title: "Email",
                                placeholder: "name@email.com",
                                text: $email,
                                focused: focusedField == .email,
                                icon: "envelope"
                            )
                            .focused($focusedField, equals: .email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()

                            AuthSecureField(
                                title: "Пароль",
                                placeholder: "••••••••",
                                text: $password,
                                focused: focusedField == .password,
                                icon: "lock"
                            )
                            .focused($focusedField, equals: .password)
                        }
                    }

                    VStack(spacing: 12) {
                        PrimaryButton(title: "Войти") {
                            router.push(.selectRole)
                        }
                        PrimaryButton(title: "Перейти к регистрации") {
                            router.push(.registration)
                        }
                        PrimaryButton(title: "Debug menu") {
                            router.push(.debugMenu)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RegistrationScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
        case confirmPassword
    }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AuthHeader(
                        title: "Регистрация",
                        subtitle: "Создайте аккаунт и получите доступ к персональному плану"
                    )

                    CardView {
                        VStack(spacing: 14) {
                            AuthTextField(
                                title: "Email",
                                placeholder: "name@email.com",
                                text: $email,
                                focused: focusedField == .email,
                                icon: "envelope"
                            )
                            .focused($focusedField, equals: .email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()

                            AuthSecureField(
                                title: "Пароль",
                                placeholder: "••••••••",
                                text: $password,
                                focused: focusedField == .password,
                                icon: "lock"
                            )
                            .focused($focusedField, equals: .password)

                            AuthSecureField(
                                title: "Повторите пароль",
                                placeholder: "••••••••",
                                text: $confirmPassword,
                                focused: focusedField == .confirmPassword,
                                icon: "lock.rotation"
                            )
                            .focused($focusedField, equals: .confirmPassword)
                        }
                    }

                    VStack(spacing: 12) {
                        PrimaryButton(title: "Создать аккаунт") {
                            router.push(.selectRole)
                        }
                        PrimaryButton(title: "Назад ко входу") {
                            router.popToRoot()
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectUserRoleView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AuthHeader(
                        title: "Выберите роль",
                        subtitle: "От роли зависит набор экранов и рабочих инструментов"
                    )

                    RoleCard(
                        title: "Coach",
                        subtitle: "Программы, аналитика, клиенты",
                        systemImage: "person.2.crop.square.stack"
                    ) {
                        router.setRoleAndContinue(.coach)
                    }

                    RoleCard(
                        title: "Athlete",
                        subtitle: "Тренировки, прогресс, AI-подсказки",
                        systemImage: "bolt.heart"
                    ) {
                        router.setRoleAndContinue(.athlete)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoachOnboardingView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AuthHeader(
                        title: "Профиль тренера",
                        subtitle: "Проверьте стартовые параметры перед началом"
                    )

                    CardView {
                        VStack(spacing: 12) {
                            OnboardingRow(title: "Специализация", value: "Силовой тренинг")
                            OnboardingRow(title: "Опыт", value: "5+ лет")
                            OnboardingRow(title: "Цель", value: "Рост результатов клиентов")
                        }
                    }

                    PrimaryButton(title: "Завершить") {
                        router.finishOnboarding()
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AthleteOnboardingView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AuthHeader(
                        title: "Профиль спортсмена",
                        subtitle: "Уточните цель и текущий уровень подготовки"
                    )

                    CardView {
                        VStack(spacing: 12) {
                            OnboardingRow(title: "Цель", value: "Сила и выносливость")
                            OnboardingRow(title: "Уровень", value: "Средний")
                            OnboardingRow(title: "Ограничения", value: "Нет")
                        }
                    }

                    PrimaryButton(title: "Завершить") {
                        router.finishOnboarding()
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AuthHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Body&Code")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)

            Text(title)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.75)

            Text(subtitle)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(3)
                .minimumScaleFactor(0.85)
        }
    }
}

private struct AuthTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let focused: Bool
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(focused ? Color.brandPrimary : Color.textSecondary)

                TextField(placeholder, text: $text)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                    .tint(Color.brandPrimary)

                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(focused ? Color.brandPrimary : Color.clear)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color.bgPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(focused ? Color.brandPrimary : Color.border, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

private struct AuthSecureField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let focused: Bool
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(focused ? Color.brandPrimary : Color.textSecondary)

                SecureField(placeholder, text: $text)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                    .tint(Color.brandPrimary)

                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(focused ? Color.brandPrimary : Color.clear)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color.bgPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(focused ? Color.brandPrimary : Color.border, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

private struct RoleCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.buttonPrimaryText)
                    .frame(width: 52, height: 52)
                    .background(Color.buttonPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.card)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct OnboardingRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    FlowCoordinatorView()
}
