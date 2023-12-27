//
//  RealmService.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import RealmSwift
import UIKit

final class RealmService {
    static let shared = RealmService()
    
    private var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    func saveMovie(_ movie: Movie) {
        guard !isMovieAlreadySaved(movie) else { return }
        
        var localMovie = movie
        // Сохраняем изображение в файловой системе, если оно есть
        if let image = movie.image {
            localMovie.localImageURL = ImageManager.shared.saveImageToFileSystem(image: image)?.absoluteString
        } else {
            print("not saved")
        }
        
        let movieObject = MovieObject(from: localMovie)
        try! realm.write {
            realm.add(movieObject)
        }
    }
    
    func setStarsToMovie(_ movie: Movie) {
        let movieObject = MovieObject(from: movie)
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
            } else {
                print("Not loaded")
            }
            return movie
        }
    }
    
    // Удаление фильма и его изображения
    func deleteMovie(_ movie: Movie) {
        // Находим объект MovieObject в Realm
        if let movieObject = realm.objects(MovieObject.self).filter("name == %@ AND year == %@", movie.name, movie.year).first {
            try! realm.write {
                realm.delete(movieObject) // Удаляем объект из Realm
            }
        }
        
        // Удаление изображения из файловой системы
        if let localImageURL = movie.localImageURL, let url = URL(string: localImageURL) {
            ImageManager.shared.deleteImageFromFileSystem(url: url)
        }
    }
    
    func isMovieAlreadySaved(_ movie: Movie) -> Bool {
        realm.objects(MovieObject.self).contains { $0.name == movie.name && $0.year == movie.year }
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



