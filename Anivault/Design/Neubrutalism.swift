import SwiftUI

// MARK: - Theme
struct NeoTheme {
    static let primary = Color(hex: "8B5CF6")
    static let secondary = Color(hex: "A7F3D0")
    static let background = Color(hex: "FEF3C7")
    static let surface = Color.white
    static let text = Color.black
    static let error = Color(hex: "FF6B6B")
    static let accentOrange = Color(hex: "FF9F1C")

    static let borderWidth: CGFloat = 3
    static let cornerRadius: CGFloat = 12
    static let shadowOffset: CGFloat = 5
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Modifiers
struct NeoBrutalismModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: NeoTheme.borderWidth)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.black)
                    .offset(x: NeoTheme.shadowOffset, y: NeoTheme.shadowOffset)
            )
    }
}

extension View {
    func neoStyle(color: Color = NeoTheme.surface, cornerRadius: CGFloat = NeoTheme.cornerRadius)
        -> some View
    {
        self.modifier(NeoBrutalismModifier(color: color, cornerRadius: cornerRadius))
    }
}

struct BlinkModifier: ViewModifier {
    @State private var isVisible = true

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(Animation.linear(duration: 0.6).repeatForever(autoreverses: true)) {
                    isVisible.toggle()
                }
            }
    }
}

extension View {
    func blinkEffect() -> some View {
        modifier(BlinkModifier())
    }
}

// MARK: - Components

struct NeoButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(NeoButtonStyle(color: color))
    }
}

struct NeoButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .background(color)
            .cornerRadius(NeoTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: NeoTheme.borderWidth)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.black)
                    .offset(
                        x: configuration.isPressed ? 0 : NeoTheme.shadowOffset,
                        y: configuration.isPressed ? 0 : NeoTheme.shadowOffset
                    )
            )
            .offset(
                x: configuration.isPressed ? NeoTheme.shadowOffset : 0,
                y: configuration.isPressed ? NeoTheme.shadowOffset : 0
            )
            .animation(Animation.easeOut(duration: 0.1), value: configuration.isPressed)
    }

    var cornerRadius: CGFloat {
        NeoTheme.cornerRadius
    }
}

struct NeoSocialButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
        }
        .buttonStyle(NeoButtonStyle(color: .white))
    }
}

struct NeoTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    @FocusState private var isFocused: Bool
    @State private var shakeOffset: CGFloat = 0
    @State private var showPassword: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black
                .frame(height: 60)
                .offset(
                    x: isFocused ? 12 : 8,
                    y: isFocused ? 12 : 8
                )

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(isFocused ? Color.black : Color.white)
                    .border(isFocused ? Color.white : Color.black, width: 4)

                HStack {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.system(size: 18, design: .monospaced))
                            .foregroundColor(isFocused ? Color.white.opacity(0.8) : Color.gray)
                            .allowsHitTesting(false)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)

                HStack {
                    if isSecure && !showPassword {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .tint(isFocused ? .white : .black)
                            .foregroundColor(isFocused ? .white : .black)
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .accentColor(isFocused ? .white : .black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .tint(isFocused ? .white : .black)
                            .foregroundColor(isFocused ? .white : .black)
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .accentColor(isFocused ? .white : .black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }

                    if isSecure {
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(isFocused ? .white : .black)
                        }
                    }

                    if isFocused && !isSecure {  // Only show blink cursor if not secure or if we want to separate it. Actually blink cursor is just a visual '|'.
                        Text("|")
                            .font(.system(size: 22, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                            .blinkEffect()
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 60)
            .offset(x: isFocused ? -4 : 0, y: isFocused ? -4 : 0)
            .offset(x: shakeOffset)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFocused)
        }
        .onChange(of: isFocused) { oldValue, newValue in
            if newValue {
                triggerShake()
            }
        }
    }

    private func triggerShake() {
        let duration = 0.05
        let intensity: CGFloat = 5

        withAnimation(.linear(duration: duration)) { shakeOffset = -intensity }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.linear(duration: duration)) { shakeOffset = intensity }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
            withAnimation(.linear(duration: duration)) { shakeOffset = -intensity }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 3) {
            withAnimation(.linear(duration: duration)) { shakeOffset = 0 }
        }
    }
}
