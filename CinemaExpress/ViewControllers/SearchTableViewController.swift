//
//  SearchTableViewController.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 26.12.2023.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviesFounded: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(MovieInfoCell.self, forCellReuseIdentifier: "MovieInfoCell")
    }
    
    @IBAction func ClearButtonTapped(_ sender: UIBarButtonItem) {
        moviesFounded = []
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesFounded.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = moviesFounded[indexPath.row]
        
        cell.configure(with: movie)
        cell.setButton(title: "Добавить")
        cell.onButtonTapped = { [weak self] in
            guard let self = self else { return }
            RealmService.shared.saveMovie(movie)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        KinopoiskApi.shared.fetchMovies(withTitle: text) { [weak self] movies in
            DispatchQueue.main.async {
                self?.moviesFounded = movies
                self?.tableView.reloadData()
            }
        }
    }
}
