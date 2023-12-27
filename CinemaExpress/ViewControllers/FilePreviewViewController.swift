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
    
    @IBOutlet var starButtons: [UIButton]!
    
    var movie: Movie!
    
    var isButtonsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        filmNameLabel.text = movie.name
        genreLabel.text = movie.genres.joined(separator: ", ")
        descriptionLabel.text = movie.description
        
        if let image = movie.image {
            imageView.image = image
        } else {
            if let movieImageUrl = movie.posterURL ,let imageUrl = URL(string: movieImageUrl) {
                KinopoiskApi.shared.loadImage(from: imageUrl) { [self] image in
                    imageView.image = image
                }
            }
        }
        
        starButtons.forEach{
            $0.isHidden = isButtonsHidden
        }
    }
}


