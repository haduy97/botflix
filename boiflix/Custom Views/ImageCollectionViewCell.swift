//
//  ImageCollectionView.swift
//  boiflix
//
//  Created by Duy Ha on 20/12/2023.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionView"
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "boiflixLogo")
        return iv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(activityIndicator)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(posterImageView.snp.centerX)
            make.centerY.equalTo(posterImageView.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        posterImageView.backgroundColor = .systemBackground
    }
    
    public func configure(with path: String) {
        activityIndicator.startAnimating()
        
        guard let url = URL(string: "\(Constants.NETWORK_IMAGE)\(path)"), path.count > 0 else {
            activityIndicator.stopAnimating()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                self?.activityIndicator.stopAnimating()
                return
            }
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let newImage = UIImage(data: data)
                
                UIView.transition(with: self?.posterImageView ?? UIView(), duration: 0.3, options: .transitionCrossDissolve) {
                    self?.posterImageView.image = newImage
                }
            }
        }
        
        task.resume()
    }

}
