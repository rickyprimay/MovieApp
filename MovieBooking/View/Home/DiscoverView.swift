//
//  ContentView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject var viewModel = MovieViewModel()
    @State var searchText: String = ""
    @StateObject var viewModelDetails = MovieDetailViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 39/255, green: 40/255, blue: 59/255)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image("me")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Text("rickyprimay")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                        SearchBarView(text: $searchText)
                            .padding(.horizontal)
                            .onChange(of: searchText) {
                                if searchText.count > 2 {
                                    viewModel.search(term: searchText)
                                }
                            }
                            .padding(.top, 5)
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                if searchText.isEmpty {
                                    if viewModel.trending.isEmpty {
                                        Text("No Results..")
                                            .foregroundColor(.white)
                                    } else {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text("Now Playing in Cinemas")
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                                .offset(y: 10)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack {
                                                    ForEach(viewModel.nowPlaying) { nowPlayingItem in
                                                        NavigationLink {
                                                            MovieDetailView(viewModel: viewModelDetails, viewModelMovie: viewModel, movie: nowPlayingItem)
                                                        } label: {
                                                            NowPlayingCardView(nowPlaying: nowPlayingItem, viewModel: viewModel)
                                                        }
                                                    }
                                                }
                                                .offset(y: -5)
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Trending Movie")
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack {
                                                    ForEach(viewModel.trending) { trendingItem in
                                                        NavigationLink {
                                                            MovieDetailView(viewModel: viewModelDetails, viewModelMovie: viewModel, movie: trendingItem)
                                                        } label: {
                                                            TrendingCardView(trendingItem: trendingItem, viewModel: viewModel)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Upcoming Movie")
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack {
                                                    ForEach(viewModel.upcoming) { upcomingItem in
                                                        NavigationLink {
                                                            MovieDetailView(viewModel: viewModelDetails, viewModelMovie: viewModel, movie: upcomingItem)
                                                        } label: {
                                                            UpcomingCardView(upComing: upcomingItem, viewModel: viewModel)
                                                        }
                                                    }
                                                }
                                                .offset(y: -5)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                } else {
                                    LazyVStack {
                                        ForEach(viewModel.searchResults) { item in
                                            NavigationLink {
                                                MovieDetailView(viewModel: viewModelDetails, viewModelMovie: viewModel, movie: item)
                                            } label: {
                                                ResultSearchView(item: item)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.getFavoritesMovie()
                        viewModel.loadTrending()
                        viewModel.loadNowPlaying()
                        await viewModel.getUpcomingMovie()
                    }
                }
            }
        }
    }
    
    #Preview {
        DiscoverView()
    }
