import Vapor

public struct Feed: Content {

    public let earthquakes: [Quake]
    public let info: String
}

