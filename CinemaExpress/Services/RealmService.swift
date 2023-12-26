//
//  RealmService.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import RealmSwift
import UIKit

class RealmService {
    static let shared = RealmService()
    
    private var realm: Realm
    
    private init() {
           realm = try! Realm()
       }

    func saveMovie(_ movie: Movie) {
           var localMovie = movie
           // Сохраняем изображение в файловой системе, если оно есть
           if let image = movie.image {
               localMovie.localImageURL = ImageManager.shared.saveImageToFileSystem(image: image)?.absoluteString
           }
           
           let movieObject = MovieObject(from: localMovie)
           try! realm.write {
               realm.add(movieObject)
           }
       }

       func loadMovies() -> [Movie] {
           let movieObjects = realm.objects(MovieObject.self)
           return movieObjects.map { obj in
               var movie = Movie(name: obj.name, year: obj.year, genres: Array(obj.genres), posterURL: obj.posterURL, description: obj.details, rating: obj.rating, image: nil, localImageURL: obj.localImageURL)
               // Загружаем изображение из файловой системы, если URL доступен
               if let localImageURL = obj.localImageURL, let url = URL(string: localImageURL) {
                   movie.image = ImageManager.shared.loadImageFromFileSystem(url: url)
               }
               return movie
           }
       }
}

class MovieObject: Object {
    @Persisted var name: String = ""
    @Persisted var year: Int = 0
    @Persisted var genres: List<String> = List<String>()
    @Persisted var posterURL: String? = nil
    @Persisted var details: String? = nil
    @Persisted var rating: Int? = nil
    @Persisted var localImageURL: String? = nil

    convenience init(from movie: Movie) {
        self.init()
        self.name = movie.name
        self.year = movie.year
        self.genres.append(objectsIn: movie.genres)
        self.posterURL = movie.posterURL
        self.details = movie.description
        self.rating = movie.rating
        self.localImageURL = movie.localImageURL
    }
}



