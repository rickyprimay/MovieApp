//
//  SearchBarView.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 15/11/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    var placeholder: String = "Search"
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(10)
                .background(Color(red: 50/255, green: 50/255, blue: 70/255))
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.system(size: 16))
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.trailing, 10)
        }
        .padding(.horizontal, 10)
        .background(Color(red: 50/255, green: 50/255, blue: 70/255))
        .cornerRadius(15)
    }
}

