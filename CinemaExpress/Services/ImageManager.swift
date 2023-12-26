//
//  ImageManager.swift
//  CinemaExpress
//
//  Created by Alexey Solop on 25.12.2023.
//

import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    
    func saveImageToFileSystem(image: UIImage) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileName = UUID().uuidString // Уникальное имя файла
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).jpg")
        
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Ошибка сохранения файла: \(error)")
            return nil
        }
    }
    
    func loadImageFromFileSystem(url: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Ошибка загрузки изображения: \(error)")
            return nil
        }
    }
    
    private init() {}
}
