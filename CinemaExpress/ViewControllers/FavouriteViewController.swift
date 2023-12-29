//
//  FavouriteViewController.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 29.12.2023.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var favoruteTableView: UITableView!
    
    var moviesDownloaded: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        favoruteTableView.delegate = self
        favoruteTableView.dataSource = self
        favoruteTableView.backgroundColor = .clear
        
        favoruteTableView.register(MovieInfoCell.self, forCellReuseIdentifier: "MovieInfoCell")
        
        moviesDownloaded = RealmService.shared.loadMovies()
        
        addObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - UITableViewDataSource
extension FavouriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesDownloaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = moviesDownloaded[indexPath.row]
        
        cell.configure(with: movie)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.onButtonTapped = { [self] in
            RealmService.shared.deleteMovie(movie)
            moviesDownloaded.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFilmInfo", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
}

// MARK: - Segue Handling
extension FavouriteViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinaion = segue.destination as? FilePreviewViewController,
              let indexPath = sender as? IndexPath else { return }
        destinaion.movie = moviesDownloaded[indexPath.row]
    }
}

// MARK: - Notification Handling
extension FavouriteViewController {
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
        favoruteTableView.reloadData()
    }
}
