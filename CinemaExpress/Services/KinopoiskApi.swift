//
//  KinopoiskApi.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import Foundation
import UIKit

/*
// Пример использования
 fetchMovies(withTitle: "Зеленая миля") { movies in
     for movie in movies {
         // Обновление UI в главном потоке
         DispatchQueue.main.async {
             self.movieInfo.text = "\(movie.name) (\(movie.year)), Жанры: \(movie.genres.joined(separator: ", ")), Постер: \(movie.posterURL ?? "нет")"

             // Загрузка изображения
             if let posterURLString = movie.posterURL, let posterURL = URL(string: posterURLString) {
                 self.loadImage(from: posterURL) { image in
                     self.poster.image = image
                 }
             } else {
                 self.poster.image = UIImage(named: "нет")
             }
         }
     }
 }
*/
final class KinopoiskApi {
    static let shared = KinopoiskApi()
    
    // Функция для запроса фильмов по названию
    func fetchMovies(withTitle title: String, completion: @escaping ([Movie]) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.kinopoisk.dev/v1.4/movie/search?page=1&limit=10&query=\(query)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("GDFD66S-NYF4KG0-G1FJA3V-S7GXJMK", forHTTPHeaderField: "X-API-KEY")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка запроса: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion([])
                return
            }
            
            do {
                // Парсинг ответа
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let docs = json["docs"] as? [[String: Any]] {
                    
                    var movies: [Movie] = []
                    
                    for doc in docs {
                        let name = doc["name"] as? String ?? "Название неизвестно"
                        let year = doc["year"] as? Int ?? 0
                        let genresArray = doc["genres"] as? [[String: Any]] ?? []
                        let genres = genresArray.compactMap { $0["name"] as? String }
                        let posterURL = (doc["poster"] as? [String: Any])?["url"] as? String
                        let description = doc["description"] as? String ?? "Описание неизвестно"
                        
                        let movie = Movie(name: name, year: year, genres: genres, posterURL: posterURL, description: description)
                        movies.append(movie)
                    }
                    
                    completion(movies)
                }
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }

    // Дополнительная функция для асинхронной загрузки изображения
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private init() {}
}
