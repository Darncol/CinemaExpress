//
//  FavoriteFilmsTableViewController.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import UIKit

class FavoriteFilmsTableViewController: UITableViewController {
    
    var moviesDownloaded: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MovieInfoCell.self, forCellReuseIdentifier: "MovieInfoCell")
        
        // Пример использования
         fetchMovies(withTitle: "Зеленая миля") { movies in
             for movie in movies {
                 // Обновление UI в главном потоке
                 DispatchQueue.main.async {
                     self.moviesDownloaded.append(movie)
                     print("added")
                     self.tableView.reloadData()
                 }
             }
         }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesDownloaded.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = moviesDownloaded[indexPath.row] // movies - это ваш массив данных
        
        cell.configure(with: movie)
        print("cell configured")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142 // Высота вашей ячейки
    }
}



