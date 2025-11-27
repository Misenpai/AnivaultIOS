import SwiftUI

struct OTPVerificationView: View {
    @EnvironmentObject var appState: AnivaultAppState
    @StateObject private var viewModel: OTPVerificationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool

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

                    ZStack {
                        // Hidden TextField for input handling
                        TextField("", text: $viewModel.otp)
                            .keyboardType(.numberPad)
                            .focused($isFocused)
                            .accentColor(.clear)
                            .foregroundColor(.clear)
                            .onChange(of: viewModel.otp) { oldValue, newValue in
                                if newValue.count > 6 {
                                    viewModel.otp = String(newValue.prefix(6))
                                }
                            }
                            .frame(width: 1, height: 1)
                            .opacity(0.01)

                        // Visual Blocks
                        HStack(spacing: 12) {
                            ForEach(0..<6, id: \.self) { index in
                                OTPBlock(
                                    digit: getDigit(at: index),
                                    isActive: isFocused
                                        && (viewModel.otp.count == index
                                            || (viewModel.otp.count == 6 && index == 5))
                                )
                                .onTapGesture {
                                    isFocused = true
                                }
                            }
                        }
                    }
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
                    .neoStyle()
            )
            .padding()
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.isVerified) { oldValue, newValue in
            if newValue {
                appState.isAuthenticated = true
                dismiss()
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    private func getDigit(at index: Int) -> String {
        if index < viewModel.otp.count {
            let stringIndex = viewModel.otp.index(viewModel.otp.startIndex, offsetBy: index)
            return String(viewModel.otp[stringIndex])
        }
        return ""
    }
}

struct OTPBlock: View {
    let digit: String
    let isActive: Bool

    var body: some View {
        ZStack {
            // Shadow
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black)
                .offset(x: isActive ? 2 : 4, y: isActive ? 2 : 4)

            // Main Box
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 3)
                )

            // Text
            Text(digit)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(.black)

            // Cursor (Blinking)
            if isActive && digit.isEmpty {
                Text("|")
                    .font(.system(size: 24, weight: .light, design: .monospaced))
                    .foregroundColor(.black)
                    .blinkEffect()
            }
        }
        .frame(width: 45, height: 55)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isActive)
    }
}
