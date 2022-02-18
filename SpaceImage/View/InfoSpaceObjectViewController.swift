//
//  InfoSpaceObjectViewController.swift
//  SpaceImage
//
//  Created by Михаил Иванов on 18.02.2022.
//

import UIKit

class InfoSpaceObjectViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var loadDateLable: UILabel!
    
    private let context = StorageManager.shared
    
    var spaceObject: SpaceLoadObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = spaceObject.date
        imageView.image = UIImage()
        loadDateLable.text = "Дата загрузки: \(spaceObject.dateLoad ?? "01.01.1970")"
        
        let spinner = showSpinner(in: imageView)
        check(spinner: spinner)
    }

    private func showSpinner(in view: UIImageView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    private func showImage(spinner: UIActivityIndicatorView) {
        NasaAPI.shared.getSpaceImage(url: spaceObject.hdurl ?? "") { [unowned self] result in
            switch result {
                case .success(let value):
                    guard let value = value as? Data else {
                        return
                    }

                    self.imageView.image = UIImage(data: value)
                    self.context.saveImage(spaceObject, imageData: value)
                    spinner.stopAnimating()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func check(spinner: UIActivityIndicatorView) {
        guard let imageData = spaceObject.image else {
            showImage(spinner: spinner)
            return
        }
        imageView.image = UIImage(data: imageData)
        spinner.stopAnimating()
    }
}
