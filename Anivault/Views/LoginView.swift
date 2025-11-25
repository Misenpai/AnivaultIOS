import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel(authService: AuthService())

    var body: some View {
        NavigationView {
            ZStack {
                NeoTheme.background
                    .ignoresSafeArea()

                GeometryReader { geo in
                    Circle()
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 100, height: 100)
                        .background(Circle().fill(NeoTheme.secondary))
                        .position(x: 50, y: 100)

                    Rectangle()
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .background(NeoTheme.accentOrange)
                        .rotationEffect(.degrees(15))
                        .position(x: geo.size.width - 40, y: geo.size.height - 100)
                        .background(
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(15))
                                .offset(x: 5, y: 5)
                                .position(x: geo.size.width - 40, y: geo.size.height - 100)
                        )
                }

                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text("AniVault")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .lineSpacing(-10)
                            .shadow(color: .black.opacity(0.2), radius: 0, x: 3, y: 3)

                        Text("Sign in to access the chaos.")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    VStack(spacing: 20) {
                        NeoTextField(
                            placeholder: "username or email",
                            text: $viewModel.identifier
                        )

                        NeoTextField(
                            placeholder: "password",
                            text: $viewModel.password,
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
                            .offset(x: -4, y: 0)
                    }

                    Spacer()

                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.black)
                            .padding()
                            .neoStyle(color: .white)
                    } else {
                        NeoButton(title: "LET'S GO ->", color: NeoTheme.primary) {
                            viewModel.login()
                        }
                    }

                    HStack {
                        Rectangle().frame(height: 2)
                        Text("OR")
                            .font(.system(size: 14, weight: .black))
                            .padding(.horizontal)
                            .background(NeoTheme.background)
                        Rectangle().frame(height: 2)
                    }
                    .foregroundColor(.black)
                    .padding(.vertical)

                    HStack(spacing: 20) {
                        NeoSocialButton(icon: "apple.logo") {
                            print("Apple Login")
                        }

                        NeoSocialButton(icon: "g.circle.fill") {
                            print("Google Login")
                        }
                    }

                    NavigationLink(destination: SignupView()) {
                        Text("Don't have an account? Sign up")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .underline()
                            .foregroundColor(.black)
                    }
                    .padding(.top, 10)
                }
                .padding(30)
            }
            .alert(isPresented: $viewModel.isAuthenticated) {
                Alert(
                    title: Text("Success"), message: Text("You are now logged in!"),
                    dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
