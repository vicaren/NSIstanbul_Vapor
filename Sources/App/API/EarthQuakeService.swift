import Vapor

public protocol EarthQuakeService {

    func getFeed(_ req: Request) throws -> Future<[Quake]>
}

