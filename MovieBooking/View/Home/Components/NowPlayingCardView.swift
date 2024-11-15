//
//  NowPlayingCardView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 15/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct NowPlayingCardView: View {
    
    let nowPlaying: Movie
    @State var isFavorite: Bool = false
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            WebImage(url: nowPlaying.backdropMiniURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 170, height: 200)
                .clipped()
                .background(
                    Rectangle()
                        .fill(Color(red: 61/255, green: 61/255, blue: 88/255))
                        .frame(width: 170, height: 200)
                )
            
            VStack(spacing: 5) {
                HStack {
                    Text(nowPlaying.title ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(width: 130, height: 40, alignment: .leading)
                    Spacer()
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .onTapGesture {
                            isFavorite.toggle()
                            Task {
                                await viewModel.postFavorite(mediaID: nowPlaying.id ?? 0, isFavorite: isFavorite)
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(nowPlaying.vote_average ?? 0, specifier: "%.1f")")
                    Spacer()
                }
                .foregroundColor(.yellow)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(width: 170)
            .background(Color(red: 61/255, green: 61/255, blue: 88/255))
        }
        .cornerRadius(10)
        .frame(width: 170, height: 250)
        .cornerRadius(10)
        .task{
            isFavorite = viewModel.favoriteMovieIds.contains(nowPlaying.id ?? 0)
        }
    }
}


#Preview {
    DiscoverView()
}
