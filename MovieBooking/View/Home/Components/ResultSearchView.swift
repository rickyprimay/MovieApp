//
//  ResultSearchView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 15/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResultSearchView: View {
    
    var item: Movie
    
    var body: some View {
        HStack {
            WebImage(url: item.poster)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 80, height: 120)
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 120)
                )
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(item.title ?? "")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(item.vote_average ?? 0, specifier: "%.1f")")
                    Spacer()
                }
                .foregroundColor(.yellow)
                .fontWeight(.heavy)
            }
            Spacer()
        }
        .padding()
        .background(Color(red: 61/255, green: 61/255, blue: 88/255))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

