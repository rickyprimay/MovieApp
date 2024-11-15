//
//  MovieDetailView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MovieDetailViewModel
    @ObservedObject var viewModelMovie: MovieViewModel
    let movie: Movie
    let headerHeight: CGFloat = 400
    @StateObject var genreViewModel = MovieGenreViewModel()
    @State var isFavorite: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 39/255, green: 40/255, blue: 59/255).ignoresSafeArea()
            
            if viewModel.isLoading {
                VStack {
//                    Spacer()
//                    ProgressView("Loading...")
//                        .font(.headline)
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .scaleEffect(2)
//                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        WebImage(url: movie.poster)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width, height: headerHeight)
                            .clipped()
                            .background(
                                Rectangle()
                                    .fill(Color(red: 61/255, green: 61/255, blue: 88/255))
                                    .frame(width: UIScreen.main.bounds.width, height: headerHeight)
                            )
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text(movie.title ?? "")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "hand.thumbsup.fill")
                                    .fontWeight(.heavy)
                                    .foregroundColor(.yellow)
                                Text("\(movie.vote_average ?? 0.0, specifier: "%.1f")")
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.yellow)
                                Text("(\(movie.vote_count ?? 0))")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text(movie.releaseYear)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 30)
                                    .background(Color(red: 61/255, green: 61/255, blue: 88/255))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(genreViewModel.genreNames(for: movie.genre_ids ?? []), id: \.self) { genreName in
                                            Text(genreName)
                                                .font(.subheadline)
                                                .fontWeight(.heavy)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color(red: 61/255, green: 61/255, blue: 88/255))
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                Spacer()
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                if let runtime = viewModel.movie?.formattedRuntime {
                                    Text(runtime)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            HStack {
                                Text("About Movie")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            Text(movie.overview ?? "")
                                .lineLimit(3)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("Cast & Crew")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(viewModel.castProfiles) { cast in
                                        CastView(cast: cast)
                                    }
                                }
                            }
                            
                            VStack{
                                Text("")
                                Text("")
                                Text("")
                                Text("")
                                Text("")
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .fontWeight(.bold)
            }
            .padding(.leading)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .onTapGesture {
                        isFavorite.toggle()
                        Task {
                            await viewModelMovie.postFavorite(mediaID: movie.id ?? 0, isFavorite: isFavorite)
                            if isFavorite {
                                viewModelMovie.favoriteMovies.append(movie)
                            } else {
                                viewModelMovie.favoriteMovies.removeAll { $0.id == movie.id }
                            }
                        }
                    }
            }
            .padding(.trailing)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task {
            await genreViewModel.getGenre(movieDetailViewModel: viewModel)
            await viewModel.movieCredits(for: movie.id ?? 0)
            await viewModel.loadCast()
            await viewModel.movieDetails(for: movie.id ?? 0)
            isFavorite = viewModelMovie.favoriteMovieIds.contains(movie.id ?? 0)
        }
    }
}
