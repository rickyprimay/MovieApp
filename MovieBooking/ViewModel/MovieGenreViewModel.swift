//
//  MovieGenreViewModel.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 15/11/24.
//

import SwiftUI

import SwiftUI

class MovieGenreViewModel: ObservableObject {
    
    @Published var genres: [Genre] = []
    
    @MainActor
    func getGenre(movieDetailViewModel: MovieDetailViewModel) async {
        movieDetailViewModel.isLoading = true
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(MovieViewModel.apiKey)&language=en-US")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let genreResponse = try JSONDecoder().decode(GenreResponse.self, from: data)
            self.genres = genreResponse.genres
        } catch {
            print("Failed to fetch genres: \(error.localizedDescription)")
        }
        movieDetailViewModel.isLoading = false
    }
    
    func genreNames(for genreIds: [Int]) -> [String] {
            return genreIds.compactMap { genreId in
                genres.first { $0.id == genreId }?.name
            }
        }
}

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

