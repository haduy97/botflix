//
//  KeyedArchiver.swift
//  boiflix
//
//  Created by Duy Ha on 30/12/2023.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()

    fileprivate var filePath: URL = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("titleImagesData")
        return path
    }()

    private init() {}

    func saveTitleImages(_ titleImages: [TitleImage]) {
        do {
            let data = try JSONEncoder().encode(titleImages)
            try data.write(to: filePath)
        } catch {
            print("Error when write data: \(error)")
        }
    }

    func loadTitleImages() -> [TitleImage] {
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let data = try Data(contentsOf: filePath)
                let titleImages = try JSONDecoder().decode([TitleImage].self, from: data)
                return titleImages
            } catch {
                print("Error when read data: \(error)")
            }
        }
        
        return []
    }
}
