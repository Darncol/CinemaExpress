//
//  Movie.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import Foundation
import UIKit

// Структура для хранения упрощенной информации о фильме
struct Movie {
    let name: String
    let year: Int
    let genres: [String]
    let posterURL: String?
    let description: String?
    var rating: Int? = nil
    var image: UIImage? = nil
    var localImageURL: String? = nil
}
