import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    router.get { req in
        return "It works!"
    }

    let api = EarthQuakeAPI.shared
    try router.register(collection: FeedController(api: api))
}
