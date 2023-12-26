//
//  FavoriteFilmsTableViewController.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import UIKit

final class FavoriteFilmsTableViewController: UITableViewController {
    
    var moviesDownloaded: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieInfoCell.self, forCellReuseIdentifier: "MovieInfoCell")
        
        moviesDownloaded = RealmService.shared.loadMovies()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTableData),
            name: .reloadDataNotification,
            object: nil
        )
    }
        
    func movieInfoCellButtonTapped(cell: MovieInfoCell) {
           guard let indexPath = tableView.indexPath(for: cell) else { return }
           let movie = moviesDownloaded[indexPath.row]
           // Логика обработки нажатия кнопки
           print("Кнопка нажата для фильма: \(movie.name)")
       }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesDownloaded.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = moviesDownloaded[indexPath.row]
        
        cell.configure(with: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    @objc private func reloadTableData() {
        moviesDownloaded = RealmService.shared.loadMovies()
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}



