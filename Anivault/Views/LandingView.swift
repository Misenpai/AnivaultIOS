import SwiftUI

struct LandingView: View {
    @State private var selectedTab: Int = 0
    @State private var selectedSeason: String = "Current"
    private let seasons = ["Last", "Current", "Next", "Archive"]
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(red: 0.996, green: 0.953, blue: 0.780)
                    .ignoresSafeArea()

                HStack {
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
                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()

                    VStack(spacing: 0) {
                        HStack(spacing: 8) {
                            ForEach(seasons, id: \.self) { season in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedSeason = season
                                    }
                                }) {
                                    Text(season)
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
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
                                        .offset(
                                            x: selectedSeason == season ? 2 : 4,
                                            y: selectedSeason == season ? 2 : 4
                                        )
                                        .shadow(
                                            color: .black,
                                            radius: 0,
                                            x: selectedSeason == season ? 0 : 2,
                                            y: selectedSeason == season ? 0 : 2
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)

                        Spacer()
                    }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)

                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)

                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                }
                .tag(2)

                ZStack {
                    Color(red: 0.996, green: 0.953, blue: 0.780).ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(3)
            }
            .accentColor(.black)
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
