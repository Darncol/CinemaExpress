//
//  SearchViewController.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 29.12.2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var moviesFounded: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        setupUI()
        
        moviesTableView.register(MovieInfoCell.self, forCellReuseIdentifier: "MovieInfoCell")
    }
    
    @IBAction func ClearButtonTapped(_ sender: UIBarButtonItem) {
        moviesFounded = []
        moviesTableView.reloadData()
        view.endEditing(true)
    }
    
    private func setupUI() {
        moviesTableView.backgroundColor = .clear
        
        searchBar.backgroundColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        KinopoiskApi.shared.fetchMovies(withTitle: text) { [weak self] movies in
            DispatchQueue.main.async {
                self?.moviesFounded = movies
                self?.moviesTableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           searchBar.resignFirstResponder()
       }
}

// MARK: - Segue Handling
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinaion = segue.destination as? FilePreviewViewController,
              let indexPath = sender as? IndexPath else { return }
        destinaion.movie = moviesFounded[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesFounded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        var movie = moviesFounded[indexPath.row]
        
        cell.configure(with: movie)
        cell.backgroundColor = .clear
        cell.setButton(title: "Добавить")
        cell.selectionStyle = .none
        cell.onButtonTapped = {
            movie.image = cell.movieImageView.image
            RealmService.shared.saveMovie(movie)
            NotificationCenter.default.post(name: .reloadDataNotification, object: nil)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetails", sender: indexPath)
    }
}
