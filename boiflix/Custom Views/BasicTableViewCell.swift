//
//  BasicTableViewCell.swift
//  boiflix
//
//  Created by Duy Ha on 21/12/2023.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    static let identifier = "BasicTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "boiflixLogo")
        iv.layer.cornerRadius = 10.0
        iv.clipsToBounds = true
        return iv
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5.0)
            make.top.equalToSuperview().offset(5.0)
            make.bottom.equalToSuperview().offset(-5.0)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.leading.equalTo(posterImageView.snp.trailing).offset(15.0)
            make.trailing.equalTo(playButton.snp.leading)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(posterImageView)
            make.centerY.equalTo(posterImageView)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.trailing.equalToSuperview().offset(-15.0)
            make.width.equalTo(30.0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with item: BasicViewModel) {
        activityIndicator.startAnimating()
        
        guard let url = URL(string: "\(Constants.NETWORK_IMAGE)\(item.pathURL)") else {
            activityIndicator.stopAnimating()
            return
        }
        
        titleLabel.text = item.titleName
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                self?.activityIndicator.stopAnimating()
                return
            }
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.posterImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }


}
