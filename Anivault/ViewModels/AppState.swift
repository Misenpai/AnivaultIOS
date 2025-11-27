import Combine
import Foundation
import SwiftUI

class AnivaultAppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
}
