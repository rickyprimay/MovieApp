//
//  MovieDetailViewModel.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI

@MainActor
class MovieDetailViewModel: ObservableObject {
    
    @Published var credits: MovieCredit?
    @Published var cast: [MovieCredit.Cast] = []
    @Published var castProfiles: [CastProfile] = []
    @Published var movie: Movie?
    @Published var isLoading: Bool = true
    
    func movieDetails(for movieID: Int) async {
        isLoading = true
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(MovieViewModel.apiKey)&language=en-US")!
        
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            self.movie = movie
        } catch {
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    func movieCredits(for movieID: Int) async {
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(MovieViewModel.apiKey)&language=en-US")!
            
            do {
                let(data, _) = try await URLSession.shared.data(from: url)
                let credits = try JSONDecoder().decode(MovieCredit.self, from: data)
                self.credits = credits
                self.cast = credits.cast.sorted(by: { $0.order < $1.order })
            } catch {
                print(error.localizedDescription)
            }
    }
    
    func loadCast() async {
        castProfiles.removeAll()
        do {
            for member in cast {
                let url = URL(string: "https://api.themoviedb.org/3/person/\(member.id)?api_key=\(MovieViewModel.apiKey)&language=en-US")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let profile = try JSONDecoder().decode(CastProfile.self, from: data)
                castProfiles.append(profile)
//                castProfiles[member.order] = profile
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

struct CastProfile: Decodable, Identifiable {
    
    let birthday: String?
    let id: Int
    let name: String
    let profile_path: String?
    
    var photoURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w200")
        return baseURL?.appending(path: profile_path ?? "")
    }
    
}

struct CastImages: Decodable {
    
    let profiles: [CastImage]
    
    struct CastImage: Decodable {
        let file_path: String
        
    }
    
}

struct MovieCredit: Decodable {
    
    let id: Int
    let cast: [Cast]
    
    struct Cast: Decodable, Identifiable {
        let name: String
        let id: Int
        let character: String
        let order: Int
    }
    
}
