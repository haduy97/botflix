//
//  HomeHeaderUIView.swift
//  boiflix
//
//  Created by Duy Ha on 18/12/2023.
//

import UIKit

protocol HomeHeaderUIViewDelegate: AnyObject {
    func homeHeaderUIView(didTapPlay item: TitleImage)
    func homeHeaderUIView(didTapDownload isTapped: Bool)
}

class HomeHeaderUIView: UIView {
    
    private var topMovie: TitleImage?
    
    public weak var delegate: HomeHeaderUIViewDelegate?
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let homeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = .init(named: "boiflixLogo")
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Add subview to superview
        addSubview(homeImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        
        //Configure Target of Buttons
        playButton.addTarget(self, action: #selector(onPlayBtnClick), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(onDownloadBtnClick), for: .touchUpInside)
        
        //Customize Constraints
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() {
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-70)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(120)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).offset(25)
            make.centerY.equalTo(playButton.snp.centerY)
            make.width.equalTo(120)
        }
    }
    
    @objc private func onPlayBtnClick() {
        guard let movie = topMovie else { return }
        delegate?.homeHeaderUIView(didTapPlay: movie)
    }
    
    @objc private func onDownloadBtnClick() {
        guard let movie = topMovie else {
            delegate?.homeHeaderUIView(didTapDownload: false)
            return
        }
        
        var storageData = StorageManager.shared.loadTitleImages()
        let isMovieExist = storageData.contains { $0.id == movie.id }
        
        guard !isMovieExist else {
            delegate?.homeHeaderUIView(didTapDownload: false)
            return
        }
    
        storageData.append(movie)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            StorageManager.shared.saveTitleImages(storageData)
            self?.delegate?.homeHeaderUIView(didTapDownload: true)
        }
    }
    
    
    public func configure(withMovie movie: TitleImage) {
        guard let path = movie.poster_path else { return }
        guard let url = URL(string: "\(Constants.NETWORK_IMAGE)\(path)"), path.count > 0 else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let newImage = UIImage(data: data)
                UIView.transition(with: self?.homeImageView ?? UIView(), duration: 0.3, options: .transitionCrossDissolve) {
                    self?.homeImageView.image = newImage
                    self?.topMovie = movie
                }
            }
        }
        
        task.resume()
    }
    

}
