import Vapor
import SwiftSoup

// MARK: - EarthQuakeAPI

public final class EarthQuakeAPI {

    private let endPoint = URL(string: "http://m.koeri.boun.edu.tr/dbs3/deprem-liste.asp")!

    public static let shared: EarthQuakeService = EarthQuakeAPI()

}

// MARK: - EarthQuakeService

extension EarthQuakeAPI: EarthQuakeService {

    public func getFeed(_ req: Request) throws -> Future<[Quake]> {

        return try req.client().get(endPoint).map { [weak self] res in
            guard
                let self = self, let data = res.http.body.data,
                let html = String(data: data, encoding: .utf8) else { return [] }

            return self.parseData(html: html)
        }
    }
}

// MARK: - HTML Parse

extension EarthQuakeAPI {

    func parseData(html: String) -> [Quake] {

        guard
            let doc: Document = try? SwiftSoup.parse(html),
            let array = try? doc.getElementsByClass("deprem_satir").array() else { return [] }

        let quakes = array.compactMap { q -> Quake? in

            guard
                let intensity = try? q.getElementsByClass("deprem_siddet").text(),
                let zone = try? q.getElementsByTag("strong").text(),
                let info = try? q.getElementsByClass("deprem_metin").text(),

                let date = matches(for: "[0-9]{2}/[0-9]{2}/[0-9]{4}", in: info).first,
                let time = matches(for: "[0-9]{2}:[0-9]{2}:[0-9]{2}", in: info).first,
                let depth = matches(for: "[0-9]{1,2}.[0-9]{1} km", in: info).first,
                let lat = matches(for: "[0-9]{2}\\.[0-9]{4}", in: info).first,
                let long = matches(for: "[0-9]{2}\\.[0-9]{4}", in: info).last

                else { return nil }

            return Quake(intensity: intensity, zone: zone, date: date, time: time, depth: depth, lat: lat, long: long)
        }

        return quakes
    }
}

// MARK: - Regex

extension EarthQuakeAPI {

    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

