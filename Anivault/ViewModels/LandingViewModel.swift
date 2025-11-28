import Combine
import Foundation

@MainActor
class LandingViewModel: ObservableObject {
    @Published var animeList: [Anime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var hasNextPage = true
    private var isFetching = false

    private let animeService: AnimeServiceProtocol

    init(container: DIContainer) {
        self.animeService = container.animeService
    }

    private var currentTab: String = "Current"

    func fetchContent(for tab: String, reset: Bool = false) {
        if reset {
            currentPage = 1
            hasNextPage = true
            animeList = []
            currentTab = tab
        }

        guard !isFetching && hasNextPage else { return }

        isFetching = true
        if animeList.isEmpty {
            isLoading = true
        }
        errorMessage = nil

        Task {
            do {
                let response: SeasonAnimeResponse
                switch tab {
                case "Last":
                    let (year, season) = getLastSeason()
                    response = try await animeService.fetchSeasonAnime(
                        year: year, season: season, page: currentPage)
                case "Next":
                    response = try await animeService.fetchUpcomingSeasonAnime(page: currentPage)
                case "Archive":
                    response = try await animeService.fetchTopAnime(page: currentPage)
                case "Current":
                    fallthrough
                default:
                    response = try await animeService.fetchCurrentSeasonAnime(page: currentPage)
                }

                if reset {
                    self.animeList = response.data
                } else {
                    self.animeList.append(contentsOf: response.data)
                }

                self.hasNextPage = response.pagination.hasNextPage
                if self.hasNextPage {
                    self.currentPage += 1
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
            self.isFetching = false
        }
    }

    private func getLastSeason() -> (Int, String) {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)

        // Seasons:
        // Winter: Jan, Feb, Mar (1, 2, 3)
        // Spring: Apr, May, Jun (4, 5, 6)
        // Summer: Jul, Aug, Sep (7, 8, 9)
        // Fall: Oct, Nov, Dec (10, 11, 12)

        // Current Season -> Last Season
        // Winter (1-3) -> Fall (Prev Year)
        // Spring (4-6) -> Winter (Current Year)
        // Summer (7-9) -> Spring (Current Year)
        // Fall (10-12) -> Summer (Current Year)

        switch month {
        case 1...3:  // Winter -> Last was Fall of previous year
            return (year - 1, "fall")
        case 4...6:  // Spring -> Last was Winter
            return (year, "winter")
        case 7...9:  // Summer -> Last was Spring
            return (year, "spring")
        default:  // Fall -> Last was Summer
            return (year, "summer")
        }
    }

    func loadMoreContent(currentItem item: Anime) {
        let thresholdIndex = self.animeList.index(self.animeList.endIndex, offsetBy: -5)
        if let itemIndex = self.animeList.firstIndex(where: { $0.id == item.id }),
            itemIndex >= thresholdIndex
        {
            fetchContent(for: currentTab)
        }
    }
}
