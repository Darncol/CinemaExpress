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
        
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - UITableViewDataSource
extension FavoriteFilmsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesDownloaded.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = moviesDownloaded[indexPath.row]
        
        cell.configure(with: movie)
        cell.onButtonTapped = { [self] in
            RealmService.shared.deleteMovie(movie)
            moviesDownloaded.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteFilmsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFilmInfo", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
}

// MARK: - Segue Handling
extension FavoriteFilmsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinaion = segue.destination as? FilePreviewViewController,
              let indexPath = sender as? IndexPath else { return }
        destinaion.movie = moviesDownloaded[indexPath.row]
    }
}

// MARK: - Notification Handling
extension FavoriteFilmsTableViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTableData),
            name: .reloadDataNotification,
            object: nil
        )
    }
    
    @objc private func reloadTableData() {
        moviesDownloaded = RealmService.shared.loadMovies()
        tableView.reloadData()
    }
}

