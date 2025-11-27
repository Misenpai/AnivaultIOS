import SwiftUI

struct LandingView: View {
    @State private var selectedTab: Int = 0
    @State private var selectedSeason: String = "Current"
    private let seasons = ["Last", "Current", "Next", "Archive"]

    // Removed init() with UIKit dependency for now

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Color(red: 0.996, green: 0.953, blue: 0.780)  // Match background color
                    .ignoresSafeArea()

                HStack {
                    // Left Corner
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .padding(.leading, 16)

                    Spacer()
                }

                // Center Title
                Text(pageTitle)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
            }
            .frame(height: 60)
            .overlay(
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(.black),
                alignment: .bottom
            )

            TabView(selection: $selectedTab) {
                // Home Tab
                // Home Tab
                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()

                    VStack(spacing: 0) {
                        // Season Navigation Tabs
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(seasons, id: \.self) { season in
                                    Button(action: {
                                        selectedSeason = season
                                    }) {
                                        Text(season)
                                            .font(
                                                .system(
                                                    size: 16, weight: .bold, design: .monospaced)
                                            )
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedSeason == season
                                                    ? NeoTheme.primary : Color.white
                                            )
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.black, lineWidth: 2)
                                            )
                                            .shadow(
                                                color: selectedSeason == season
                                                    ? Color.black : Color.clear, radius: 0, x: 4,
                                                y: 4)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 20)
                        }

                        Spacer()
                    }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)

                // Search Tab
                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)

                // Library Tab
                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                }
                .tag(2)

                // Profile Tab
                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(3)
            }
            .accentColor(.black)  // Selected tab color
        }
    }

    private var pageTitle: String {
        switch selectedTab {
        case 0: return "Home"
        case 1: return "Search"
        case 2: return "Library"
        case 3: return "Profile"
        default: return ""
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
