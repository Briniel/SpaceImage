//
//  SpaceObjectCell.swift
//  SpaceImage
//
//  Created by Михаил Иванов on 18.02.2022.
//

import Foundation

import UIKit

class SpaceObjectCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageSpace: UIImageView!

    private let context = StorageManager.shared

    func configure(with spaceObject: SpaceLoadObject) {
        titleLabel.text = spaceObject.title

        guard let imageData = spaceObject.image else {
            loadImage(spaceObject.hdurl ?? "", spaceObject: spaceObject)
            return
        }
        imageSpace.image = UIImage(data: imageData)
    }

    private func loadImage(_ url: String, spaceObject: SpaceLoadObject) {
        NasaAPI.shared.getSpaceImage(url: url) { [unowned self] result in
            switch result {
                case .success(let value):
                    guard let value = value as? Data else {
                        return
                    }
                    imageSpace.image = UIImage(data: value)
                    context.saveImage(spaceObject, imageData: value)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
