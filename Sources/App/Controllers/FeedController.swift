import Vapor

public struct FeedController: RouteCollection {

    private let api: EarthQuakeService

    public init(api: EarthQuakeService) {
        self.api = api
    }

    public func boot(router: Router) throws {
        let routers = router.grouped("api", "feed")

        routers.get(use: index)
    }

    func index(_ req: Request) throws -> Future<Feed> {
        return try api.getFeed(req).map { earthquakes -> Feed in
            return Feed(earthquakes: earthquakes, info: "Bu bilgiler koeri.boun.edu.tr sitesi üzerinden alınmıştır")
        }
    }
}


