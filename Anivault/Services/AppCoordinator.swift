import SwiftUI
import Combine

enum AppRoute: Hashable {
    case login
    case signup
    case otpVerification(email: String)
    case home
}

class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentRoute: AppRoute = .login

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func goBack() {
        path.removeLast()
    }

    func resetToRoot() {
        path.removeLast(path.count)
    }

    func setRoot(_ route: AppRoute) {
        path = NavigationPath()
        currentRoute = route
    }
}
