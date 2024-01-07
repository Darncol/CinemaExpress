//
//  PreviewViewController.swift
//  CinemaExpress
//
//  Created by Alina Krestnikova on 25.12.2023.
//

import UIKit

final class FilePreviewViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.yellow.cgColor
        
        filmNameLabel.text = movie.name
        genreLabel.text = movie.genres.joined(separator: ", ")
        descriptionLabel.text = movie.description
        
        if let image = movie.image {
            imageView.image = image
            activityIndicator.stopAnimating()
        } else {
            if let movieImageUrl = movie.posterURL ,let imageUrl = URL(string: movieImageUrl) {
                KinopoiskApi.shared.loadImage(from: imageUrl) { [self] image in
                    imageView.image = image
                    activityIndicator.stopAnimating()
                }
            } else {
                imageView.image = UIImage(named: "noPoster")
                activityIndicator.stopAnimating()
            }
        }
    }
}


