//
//  MovieInfoCell.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import UIKit

final class MovieInfoCell: UITableViewCell {
    let movieImageView = UIImageView()
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let genreLabel = UILabel()
    let viewButton = UIButton()
    
    var onButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        setupMovieImageView()
        setupTitleLabel()
        setupYearLabel()
        setupGenreLabel()
        setupViewButton()
        setupConstraints()
    }
}

// MARK: - Button Interaction
extension MovieInfoCell {
    @objc private func buttonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            // Уменьшаем прозрачность кнопки при нажатии
            self.viewButton.alpha = 0.5
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                // Возвращаем прозрачность кнопки к нормальному состоянию
                self.viewButton.alpha = 1.0
            }
        }
        onButtonTapped?()
    }
}

// MARK: - Configuration
extension MovieInfoCell {
    // Вы можете добавить метод для конфигурации содержимого ячейки
    func configure(with movie: Movie) {
        
        // movie - это ваша модель данных, которая содержит информацию для каждой ячейки
        titleLabel.text = movie.name
        yearLabel.text = "\(movie.year)"
        genreLabel.text = movie.genres.joined(separator: ", ")
        
        // Загрузите изображение в movieImageView
        DispatchQueue.main.async { [self] in
            if let localImageURL = movie.localImageURL, let url = URL(string: localImageURL), let localImage = ImageManager.shared.loadImageFromFileSystem(url: url) {
                movieImageView.image = localImage
            } else {
                // Если изображение отсутствует на устройстве, загружаем его из интернета
                if let posterURLString = movie.posterURL, let posterURL = URL(string: posterURLString) {
                    KinopoiskApi.shared.loadImage(from: posterURL) { [weak self] image in
                        self?.movieImageView.image = image
                    }
                } else {
                    movieImageView.image = UIImage(systemName: "star") // Заглушка, если изображение отсутствует
                }
            }
        }
    }
    
    func setButton(title: String) {
        viewButton.setTitle(title, for: .normal)
    }
}

// MARK: - Setup UI
private extension MovieInfoCell {
    func setupMovieImageView() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieImageView)
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    func setupYearLabel() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(yearLabel)
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    func setupGenreLabel() {
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)
        genreLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        genreLabel.numberOfLines = 0
    }
    
    func setupViewButton() {
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewButton)
        viewButton.setTitle("Посмотрел", for: .normal)
        viewButton.backgroundColor = .systemBlue
        viewButton.setTitleColor(.white, for: .normal)
        viewButton.layer.cornerRadius = 15
        viewButton.clipsToBounds = true
        viewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            viewButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            viewButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            viewButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            viewButton.heightAnchor.constraint(equalToConstant: 30),
            viewButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
