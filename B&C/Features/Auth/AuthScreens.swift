import SwiftUI

struct LoginScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showContent = false
    @State private var animateGlow = false
    @FocusState private var focusedField: LoginField?

    private enum LoginField {
        case email
        case password
    }

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
                .frame(width: 280, height: 280)
                .blur(radius: 30)
                .offset(x: 140, y: -220)
                .scaleEffect(animateGlow ? 1.06 : 0.98)
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: animateGlow)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 220, height: 220)
                .blur(radius: 20)
                .offset(x: -140, y: 200)

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Body&Code")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))

                        Text("Войти в систему")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Тренировки, прогресс и AI‑подсказки в одном месте.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(.easeOut(duration: 0.5), value: showContent)

                    VStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            TextField("name@email.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .focused($focusedField, equals: .email)
                                .padding(12)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(focusedField == .email ? Color.brandPrimary : Color.clear, lineWidth: 1.5)
                                        .shadow(color: focusedField == .email ? Color.brandPrimary.opacity(0.6) : .clear, radius: 10, x: 0, y: 0)
                                )
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.brandPrimary.opacity(0.95))
                                        .padding(.trailing, 10)
                                        .opacity(focusedField == .email ? 1 : 0)
                                        .scaleEffect(focusedField == .email ? 1 : 0.8)
                                        .animation(.easeOut(duration: 0.2), value: focusedField == .email)
                                }
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Пароль")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            SecureField("••••••••", text: $password)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .password)
                                .padding(12)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(focusedField == .password ? Color.brandPrimary : Color.clear, lineWidth: 1.5)
                                        .shadow(color: focusedField == .password ? Color.brandPrimary.opacity(0.6) : .clear, radius: 10, x: 0, y: 0)
                                )
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.brandPrimary.opacity(0.95))
                                        .padding(.trailing, 10)
                                        .opacity(focusedField == .password ? 1 : 0)
                                        .scaleEffect(focusedField == .password ? 1 : 0.8)
                                        .animation(.easeOut(duration: 0.2), value: focusedField == .password)
                                }
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.55).delay(0.05), value: showContent)

                    VStack(spacing: 12) {
                        PrimaryButton(title: "Login") { router.push(.selectRole) }
                        PrimaryButton(title: "Go to Registration") { router.push(.registration) }
                        PrimaryButton(title: "Debug menu") { router.push(.debugMenu) }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 24)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)

                    HStack(spacing: 12) {
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                        Text("или")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.caption)
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 28)
                    .animation(.easeOut(duration: 0.6).delay(0.15), value: showContent)

                    HStack(spacing: 12) {
                        SocialButton(title: "Apple", systemImage: "apple.logo")
                        SocialButton(title: "Google", systemImage: "globe")
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 32)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showContent = true
            animateGlow = true
        }
    }
}

private struct SocialButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct RegistrationScreenView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showContent = false
    @State private var animateGlow = false
    @FocusState private var focusedField: RegistrationField?

    private enum RegistrationField {
        case email
        case password
        case confirmPassword
    }

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
                .frame(width: 280, height: 280)
                .blur(radius: 30)
                .offset(x: -120, y: -220)
                .scaleEffect(animateGlow ? 1.06 : 0.98)
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: animateGlow)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 220, height: 220)
                .blur(radius: 20)
                .offset(x: 140, y: 200)

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Body&Code")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))

                        Text("Создать аккаунт")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Заполни данные и получи персональный план.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(.easeOut(duration: 0.5), value: showContent)

                    VStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            TextField("name@email.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .focused($focusedField, equals: .email)
                                .padding(12)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(focusedField == .email ? Color.brandPrimary : Color.clear, lineWidth: 1.5)
                                        .shadow(color: focusedField == .email ? Color.brandPrimary.opacity(0.6) : .clear, radius: 10, x: 0, y: 0)
                                )
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.brandPrimary.opacity(0.95))
                                        .padding(.trailing, 10)
                                        .opacity(focusedField == .email ? 1 : 0)
                                        .scaleEffect(focusedField == .email ? 1 : 0.8)
                                        .animation(.easeOut(duration: 0.2), value: focusedField == .email)
                                }
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Пароль")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            SecureField("••••••••", text: $password)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .password)
                                .padding(12)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(focusedField == .password ? Color.brandPrimary : Color.clear, lineWidth: 1.5)
                                        .shadow(color: focusedField == .password ? Color.brandPrimary.opacity(0.6) : .clear, radius: 10, x: 0, y: 0)
                                )
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.brandPrimary.opacity(0.95))
                                        .padding(.trailing, 10)
                                        .opacity(focusedField == .password ? 1 : 0)
                                        .scaleEffect(focusedField == .password ? 1 : 0.8)
                                        .animation(.easeOut(duration: 0.2), value: focusedField == .password)
                                }
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Повторите пароль")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            SecureField("••••••••", text: $confirmPassword)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .confirmPassword)
                                .padding(12)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(focusedField == .confirmPassword ? Color.brandPrimary : Color.clear, lineWidth: 1.5)
                                        .shadow(color: focusedField == .confirmPassword ? Color.brandPrimary.opacity(0.6) : .clear, radius: 10, x: 0, y: 0)
                                )
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.brandPrimary.opacity(0.95))
                                        .padding(.trailing, 10)
                                        .opacity(focusedField == .confirmPassword ? 1 : 0)
                                        .scaleEffect(focusedField == .confirmPassword ? 1 : 0.8)
                                        .animation(.easeOut(duration: 0.2), value: focusedField == .confirmPassword)
                                }
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.55).delay(0.05), value: showContent)

                    VStack(spacing: 12) {
                        PrimaryButton(title: "Create account") { router.push(.selectRole) }
                        PrimaryButton(title: "Back to Login") { router.popToRoot() }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 24)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showContent = true
            animateGlow = true
        }
    }
}

struct SelectUserRoleView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var showContent = false
    @State private var animateGlow = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.bgPrimary, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.brandPrimary.opacity(0.2))
                .frame(width: 260, height: 260)
                .blur(radius: 30)
                .offset(x: 120, y: -200)
                .scaleEffect(animateGlow ? 1.06 : 0.98)
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: animateGlow)

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Выберите роль")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("От этого зависит набор инструментов и экранов.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(.easeOut(duration: 0.5), value: showContent)

                    VStack(spacing: 12) {
                        RoleCard(
                            title: "Coach",
                            subtitle: "Создание программ, управление клиентами",
                            systemImage: "person.2.crop.square.stack"
                        ) {
                            router.setRoleAndContinue(.coach)
                        }

                        RoleCard(
                            title: "Athlete",
                            subtitle: "Тренировки, прогресс, AI‑подсказки",
                            systemImage: "bolt.heart"
                        ) {
                            router.setRoleAndContinue(.athlete)
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.55).delay(0.05), value: showContent)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showContent = true
            animateGlow = true
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
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.brandPrimary)
                    .frame(width: 46, height: 46)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular, design: .serif))
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct CoachOnboardingView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var showContent = false
    @State private var animateGlow = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.bgPrimary, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.brandPrimary.opacity(0.2))
                .frame(width: 260, height: 260)
                .blur(radius: 30)
                .offset(x: 120, y: -200)
                .scaleEffect(animateGlow ? 1.06 : 0.98)
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: animateGlow)

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Coach Onboarding")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Настрой профиль тренера: специализация, опыт, цели.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(.easeOut(duration: 0.5), value: showContent)

                    VStack(spacing: 12) {
                        OnboardingRow(title: "Специализация", value: "Силовой тренинг")
                        OnboardingRow(title: "Опыт", value: "5+ лет")
                        OnboardingRow(title: "Цели", value: "Рост клиентов и ретеншн")
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.55).delay(0.05), value: showContent)

                    PrimaryButton(title: "Finish onboarding") { router.finishOnboarding() }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 24)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showContent = true
            animateGlow = true
        }
    }
}

struct AthleteOnboardingView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var showContent = false
    @State private var animateGlow = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.bgPrimary, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.brandPrimary.opacity(0.2))
                .frame(width: 260, height: 260)
                .blur(radius: 30)
                .offset(x: -120, y: -200)
                .scaleEffect(animateGlow ? 1.06 : 0.98)
                .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: animateGlow)

            NoiseOverlay()
                .opacity(0.06)
                .blendMode(.softLight)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Athlete Onboarding")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Настрой параметры тренинга: цели, уровень, ограничения.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(.easeOut(duration: 0.5), value: showContent)

                    VStack(spacing: 12) {
                        OnboardingRow(title: "Цели", value: "Сила + Выносливость")
                        OnboardingRow(title: "Уровень", value: "Средний")
                        OnboardingRow(title: "Ограничения", value: "Нет")
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.55).delay(0.05), value: showContent)

                    PrimaryButton(title: "Finish onboarding") { router.finishOnboarding() }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 24)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showContent = true
            animateGlow = true
        }
    }
}

private struct OnboardingRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white.opacity(0.6))
                .font(.caption)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .padding(.vertical, 8)
    }
}

private struct NoiseOverlay: View {
    @State private var drift = false

    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let dotCount = 2800
                var rng = SeededGenerator(seed: 42)
                for _ in 0..<dotCount {
                    let x = CGFloat.random(in: 0...size.width, using: &rng)
                    let y = CGFloat.random(in: 0...size.height, using: &rng)
                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(.white.opacity(0.08)))
                }
            }
            .blur(radius: 0.6)
            .offset(x: drift ? 8 : -8, y: drift ? -6 : 6)
            .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: drift)
        }
        .allowsHitTesting(false)
        .onAppear {
            drift = true
        }
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
