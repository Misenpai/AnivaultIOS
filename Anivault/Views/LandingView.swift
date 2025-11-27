import SwiftUI

struct LandingView: View {
    @State private var selectedTab: Int = 0

    // Removed init() with UIKit dependency for now

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            ZStack {
                Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                Text("Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            // Search Tab
            ZStack {
                Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .tag(1)

            // Library Tab
            ZStack {
                Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                Text("Library")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .tabItem {
                Image(systemName: "books.vertical.fill")
                Text("Library")
            }
            .tag(2)

            // Profile Tab
            ZStack {
                Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(3)
        }
        .accentColor(.black)  // Selected tab color
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
