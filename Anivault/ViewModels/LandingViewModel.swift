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

    func fetchCurrentSeason(reset: Bool = false) {
        if reset {
            currentPage = 1
            hasNextPage = true
            animeList = []
        }

        guard !isFetching && hasNextPage else { return }

        isFetching = true
        if animeList.isEmpty {
            isLoading = true
        }
        errorMessage = nil

        Task {
            do {
                let response = try await animeService.fetchCurrentSeasonAnime(page: currentPage)
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

    func loadMoreContent(currentItem item: Anime) {
        let thresholdIndex = self.animeList.index(self.animeList.endIndex, offsetBy: -5)
        if let itemIndex = self.animeList.firstIndex(where: { $0.id == item.id }),
            itemIndex >= thresholdIndex
        {
            fetchCurrentSeason()
        }
    }
}
