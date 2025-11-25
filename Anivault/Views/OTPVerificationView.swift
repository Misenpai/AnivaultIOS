import SwiftUI

struct OTPVerificationView: View {
    @StateObject private var viewModel: OTPVerificationViewModel
    @Environment(\.dismiss) var dismiss

    init(email: String, authService: AuthServiceProtocol) {
        _viewModel = StateObject(
            wrappedValue: OTPVerificationViewModel(email: email, authService: authService))
    }

    var body: some View {
        ZStack {
            NeoTheme.background
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Verify Email")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(NeoTheme.text)

                Text("Enter the 6-digit code sent to \(viewModel.email)")
                    .font(.body)
                    .foregroundColor(NeoTheme.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("OTP Code")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)

                    NeoTextField(
                        placeholder: "123456",
                        text: $viewModel.otp
                    )
                    .keyboardType(.numberPad)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                NeoButton(
                    title: "Verify",
                    color: NeoTheme.primary,
                    action: {
                        viewModel.verify()
                    }
                )
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.7 : 1)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .neoStyle() // replaced .neoShadow() with .neoStyle()
            )
            .padding()
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.isVerified) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
