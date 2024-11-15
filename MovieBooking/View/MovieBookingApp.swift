//
//  MovieBookingApp.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI

@main
struct MovieBookingApp: App {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray.withAlphaComponent(0.5)
        UITabBar.appearance().backgroundColor = UIColor(red: 39/255, green: 40/255, blue: 59/255, alpha: 1)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                DiscoverView()
                    .tabItem{
                        Image(systemName: "popcorn")
                            .foregroundColor(.white)
                    }
                
                FavoritesMovieView(viewModel: MovieViewModel())
                    .tabItem{
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                    }
                
                Text("Ticket")
                    .tabItem{
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.white)
                    }
            }
            .tint(.white)
        }
    }
}

