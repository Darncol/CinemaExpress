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
}



