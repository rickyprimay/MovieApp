//
//  CastProfile.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 15/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CastView: View {
    
    let cast: CastProfile
    
    var body: some View {
        
        VStack{
            WebImage(url: cast.photoURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 80, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 130)
                )
            Text(cast.name)
                .foregroundColor(.white)
                .frame(width: 100)
        }
        
    }
    
}
