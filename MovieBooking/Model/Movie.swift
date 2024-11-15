//
//  TrendingItemModel.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI

struct Movie: Identifiable, Decodable {
    
    let adult: Bool?
    let id: Int?
    let poster_path: String?
    let title: String?
    let overview: String?
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let runtime: Int?
    
    var backdropURL: URL?{
        guard let backdropPath = backdrop_path else { return nil }
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w400")!
        return baseURL.appendingPathComponent(backdropPath)
    }
    
    var postThumbnail: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w100")!
        return baseURL.appending(path: poster_path ?? "")
    }
    
    var backdropMiniURL: URL?{
        guard let backdropPath = backdrop_path else { return nil }
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        return baseURL.appendingPathComponent(backdropPath)
    }
    
    var poster: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        return baseURL.appending(path: poster_path ?? "")
    }
    
    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    var releaseYear: String {
        guard let dateString = release_date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    static var mock: Movie{
        return Movie(
            adult: false,
            id: 1,
            poster_path: "https://image.tmdb.org/t/p/w500",
            title: "Free Guy",
            overview: "The best movie ever",
            release_date: "2022-01-01",
            vote_average: 5.5,
            vote_count: 100,
            backdrop_path: "https://image.tmdb.org/t/p/w500",
            genre_ids: [1, 2, 3],
            runtime: 120
        )
    }
}
