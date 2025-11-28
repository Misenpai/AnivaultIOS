import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel: SignupViewModel
    @Environment(\.presentationMode) var presentationMode

    init(container: DIContainer, coordinator: AppCoordinator) {
        _viewModel = StateObject(
            wrappedValue: SignupViewModel(container: container, coordinator: coordinator))
    }

    var body: some View {
        ZStack {
            NeoTheme.background
                .ignoresSafeArea()

            GeometryReader { geo in
                Circle()
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: 150, height: 150)
                    .background(Circle().fill(NeoTheme.secondary))
                    .position(x: geo.size.width - 50, y: 100)

                Rectangle()
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: 60, height: 60)
                    .background(NeoTheme.accentOrange)
                    .rotationEffect(.degrees(-15))
                    .position(x: 40, y: geo.size.height - 80)
            }

            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text("Join the Chaos")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .shadow(color: .black.opacity(0.2), radius: 0, x: 3, y: 3)

                        Text("Create your account now.")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    VStack(spacing: 20) {

                        NeoTextField(
                            placeholder: "email",
                            text: $viewModel.email
                        )

                        NeoTextField(
                            placeholder: "password",
                            text: $viewModel.password,
                            isSecure: true
                        )

                        NeoTextField(
                            placeholder: "confirm password",
                            text: $viewModel.confirmPassword,
                            isSecure: true
                        )
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(NeoTheme.error)
                            .padding(8)
                            .background(Color.white)
                            .border(Color.black, width: 2)
                    }

                    Spacer().frame(height: 20)

                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.black)
                            .padding()
                            .neoStyle(color: .white)
                    } else {
                        NeoButton(title: "SIGN UP ->", color: NeoTheme.primary) {
                            viewModel.register()
                        }
                    }

                    Button(action: {
                        viewModel.navigateToLogin()
                    }) {
                        Text("Already have an account? Log in")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .underline()
                            .foregroundColor(.black)
                    }
                    .padding(.top, 10)
                }
                .padding(30)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(container: DIContainer(), coordinator: AppCoordinator())
    }
}
