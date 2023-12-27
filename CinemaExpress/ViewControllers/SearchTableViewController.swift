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
    
}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        KinopoiskApi.shared.fetchMovies(withTitle: text) { [weak self] movies in
            DispatchQueue.main.async {
                self?.moviesFounded = movies
                self?.tableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - Segue Handling
extension SearchTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinaion = segue.destination as? FilePreviewViewController,
              let indexPath = sender as? IndexPath else { return }
        destinaion.movie = moviesFounded[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesFounded.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        var movie = moviesFounded[indexPath.row]
        
        cell.configure(with: movie)
        cell.setButton(title: "Добавить")
        cell.onButtonTapped = {
            movie.image = cell.movieImageView.image
            RealmService.shared.saveMovie(movie)
            NotificationCenter.default.post(name: .reloadDataNotification, object: nil)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        performSegue(withIdentifier: "movieDetails", sender: indexPath)
    }
}
