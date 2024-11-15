//
//  MovieDBViewModel.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI

@MainActor
class MovieViewModel: ObservableObject{
    
    static let apiKey = "3c07bac338e3265a24628b8a5ee24057"
    static let accountId = 21629387
    var sessionId = "a236b20b5ba43a05f24a68aac4589cb6705b1e3a"
    
    @Published var trending: [Movie] = []
    @Published var searchResults: [Movie] = []
    @Published var nowPlaying: [Movie] = []
    @Published var favoriteMovieIds: Set<Int> = []
    @Published var favoriteMovies: [Movie] = []
    @Published var upcoming: [Movie] = []
    
    func getUpcomingMovie() async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(MovieViewModel.apiKey)&language=en-US&page=1")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(MovieResults.self, from: data)
            upcoming = results.results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func postFavorite(mediaID: Int, isFavorite: Bool) async {
            let url = URL(string: "https://api.themoviedb.org/3/account/\(MovieViewModel.accountId)/favorite?api_key=\(MovieViewModel.apiKey)&session_id=\(sessionId)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "media_type": "movie",
                "media_id": mediaID,
                "favorite": isFavorite
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Favorite status updated successfully.")
                    if isFavorite {
                        favoriteMovieIds.insert(mediaID)
                    } else {
                        favoriteMovieIds.remove(mediaID)
                    }
                } else {
                    let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                    print("Failed to update favorite status: \(responseString)")
                }
            } catch {
                print("Error updating favorite status:", error.localizedDescription)
            }
        }
        
        func getFavoritesMovie() async {
            let url = URL(string: "https://api.themoviedb.org/3/account/\(MovieViewModel.accountId)/favorite/movies?api_key=\(MovieViewModel.apiKey)&session_id=\(sessionId)&language=en-US&page=1")!
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(MovieResults.self, from: data)
                favoriteMovieIds = Set(results.results.compactMap { $0.id })
            } catch {
                print("Error loading favorites:", error.localizedDescription)
            }
        }
    
    func loadFavoriteMovies() async {
            let url = URL(string: "https://api.themoviedb.org/3/account/\(MovieViewModel.accountId)/favorite/movies?api_key=\(MovieViewModel.apiKey)&session_id=\(sessionId)&language=en-US&page=1")!
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(MovieResults.self, from: data)
                favoriteMovies = results.results
            } catch {
                print("Error loading favorites:", error.localizedDescription)
            }
        }
    
    func loadNowPlaying() {
        Task{
            let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieViewModel.apiKey)&language=en-US&page=1")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(MovieResults.self, from: data)
                nowPlaying = results.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadTrending() {
        Task{
            let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(MovieViewModel.apiKey)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(MovieResults.self, from: data)
                trending = results.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func search(term: String) {
        Task {
            let query = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(MovieViewModel.apiKey)&query=\(query)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(MovieResults.self, from: data)
                searchResults = results.results
            } catch {
                print("Search Error: \(error.localizedDescription)")
                searchResults = []
            }
        }
    }
    
}


