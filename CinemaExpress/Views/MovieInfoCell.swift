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
        // Настройка интерфейса ячейки
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Настройка интерфейса ячейки
        setupUI()
    }
    
    private func setupUI() {
        // Добавляем элементы на contentView ячейки
        [movieImageView, titleLabel, yearLabel, genreLabel, viewButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            viewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        
        
        // ImageView Constraints
        //        NSLayoutConstraint.activate([
        //            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        //            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        //            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        //            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor)
        //        ])
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // Задаем фиксированную ширину
            movieImageView.widthAnchor.constraint(equalToConstant: 100) // Например, ширина 100
        ])
        
        
        // Title Label Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        // Year Label Constraints
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        // Genre Label Constraints
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        // View Button Constraints
        NSLayoutConstraint.activate([
            viewButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            viewButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            viewButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            viewButton.heightAnchor.constraint(equalToConstant: 30),
            viewButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // Настройки для элементов UI
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        genreLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        viewButton.setTitle("Посмотрел", for: .normal)
        viewButton.backgroundColor = .systemBlue
        viewButton.setTitleColor(.white, for: .normal)
        viewButton.layer.cornerRadius = 15
        viewButton.clipsToBounds = true
    }
    
    // Вы можете добавить метод для конфигурации содержимого ячейки
    func configure(with movie: Movie) {
        
        // movie - это ваша модель данных, которая содержит информацию для каждой ячейки
        titleLabel.text = movie.name
        yearLabel.text = "\(movie.year)"
        genreLabel.text = movie.genres.joined(separator: ", ")
        
        // Загрузите изображение в movieImageView
        DispatchQueue.main.async { [self] in
            // Загрузка изображения
            if let posterURLString = movie.posterURL, let posterURL = URL(string: posterURLString) {
                KinopoiskApi.shared.loadImage(from: posterURL) { [self] image in
                    movieImageView.image = image
                }
            } else {
                movieImageView.image = UIImage(systemName: "star")
            }
        }
    }
    
    func setButton(title: String) {
        viewButton.setTitle(title, for: .normal)
    }
    
}

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
