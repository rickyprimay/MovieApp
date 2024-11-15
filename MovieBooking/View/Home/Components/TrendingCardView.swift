//
//  TrendingCardView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrendingCardView: View {
    let trendingItem: Movie
    @ObservedObject var viewModel: MovieViewModel
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            WebImage(url: trendingItem.backdropURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 340, height: 200)
                .clipped()
                .background(
                    Rectangle()
                        .fill(Color(red: 61/255, green: 61/255, blue: 88/255))
                        .frame(width: 340, height: 200)
                )
            
            VStack {
                HStack {
                    Text(trendingItem.title ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: 280, alignment: .leading)
                    Spacer()
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .onTapGesture {
                            isFavorite.toggle()
                            Task {
                                await viewModel.postFavorite(mediaID: trendingItem.id ?? 0, isFavorite: isFavorite)
                                if isFavorite {
                                    viewModel.favoriteMovies.append(trendingItem)
                                } else {
                                    viewModel.favoriteMovies.removeAll { $0.id == trendingItem.id }
                                }
                            }
                        }
                }
                
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(trendingItem.vote_average ?? 0, specifier: "%.1f")")
                    Spacer()
                }
                .foregroundColor(.yellow)
            }
            .padding()
            .background(Color(red: 61/255, green: 61/255, blue: 88/255))
        }
        .cornerRadius(10)
        .onAppear {
            isFavorite = viewModel.favoriteMovieIds.contains(trendingItem.id ?? 0)
        }
    }
}
