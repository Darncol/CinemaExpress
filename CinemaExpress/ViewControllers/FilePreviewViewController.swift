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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmNameLabel.text = movie.name
        genreLabel.text = movie.genres.joined(separator: ", ")
        descriptionLabel.text = movie.description
        imageView.image = movie.image
    }
}
