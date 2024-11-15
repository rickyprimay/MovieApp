//
//  FavoritesMovieView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 15/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Text("Favorite Movies")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.white)
                    
                    ForEach(viewModel.favoriteMovies, id: \.id) { movie in
                        CardFavoritesMovie(movie: movie, viewModel: viewModel)
                            .frame(width: geo.size.width * 0.9, height: 200)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                Task {
                    await viewModel.loadFavoriteMovies()
                }
            }
        }
        .background(Color(red: 39/255, green: 40/255, blue: 59/255).ignoresSafeArea())
    }
}

#Preview {
    FavoritesMovieView(viewModel: MovieViewModel())
}

struct CardFavoritesMovie: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        HStack {
            WebImage(url: movie.poster)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 100, height: 150)
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)
                )
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(movie.title ?? "")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .onTapGesture {
                            Task {
                                await viewModel.postFavorite(mediaID: movie.id ?? 0, isFavorite: false)
                                withAnimation {
                                    viewModel.favoriteMovies.removeAll { $0.id == movie.id }
                                }
                            }
                        }
                }
                
                Text("Rating: \(movie.vote_average ?? 0, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                
                Text(movie.overview ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
        .background(Color(red: 61/255, green: 61/255, blue: 88/255))
        .cornerRadius(10)
    }
}
