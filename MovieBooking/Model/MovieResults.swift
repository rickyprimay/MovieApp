//
//  TrendingResultsModel.swift
//  MovieBooking
//
//  Created by Ricky Primayuda Putra on 14/11/24.
//

import SwiftUI

struct MovieResults: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
