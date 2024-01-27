//
//  PreviewViewController.swift
//  boiflix
//
//  Created by Duy Ha on 26/12/2023.
//

import UIKit
import SnapKit
import WebKit

class PreviewViewController: BaseViewController {
    
    private var movie: TitleImage?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22.0, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        
        return label
    }()
    
    private let customTopBar: CustomTopBarUIView = {
        let custom = CustomTopBarUIView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 80.0)))
        return custom
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 5.0
        button.backgroundColor = UIColor(hex: "#677DE1")
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let webView: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set superview
        view.backgroundColor = .systemBackground
        
        //Add subview to superview
        for e in [titleLabel, overviewLabel, customTopBar, downloadButton, webView] {
            view.addSubview(e)
        }
        
        //Config subview
        customTopBar.topTitle.text = "Trailer"
        customTopBar.delegate = self
        downloadButton.addTarget(self, action: #selector(onDownloadBtnTapped), for: .touchUpInside)
        
        //Customize constraints
        applyConstraints()
        
    }
    
    private func applyConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(customTopBar.snp.bottom).offset(10.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().offset(15.0)
            make.trailing.equalToSuperview()
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15.0)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(10.0)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(overviewLabel.snp.bottom).offset(30.0)
            make.width.equalTo(140.0)
            make.height.equalTo(45.0)
        }
    }

    @objc private func onDownloadBtnTapped() {
        guard let movie = movie else { return }
        
        var data: [TitleImage] = StorageManager.shared.loadTitleImages()
        let isMovieExist = data.contains { $0.id == movie.id }
        
        guard !isMovieExist else {
            popUpToast(title: "Failed", subTitle: "This movie already exists in the download section")?.show()
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            data.append(movie)
            StorageManager.shared.saveTitleImages(data)
            
            self?.popUpToast(title: "Successful", subTitle: "Added movie to download section")?.show()
        }
    }
    
    public func configure(with model: PreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverView
        
        guard let url = URL(string: "\(Constants.YTB_EMBED_URL)/\(model.youtubeView.id.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
    }
    
    public func addTitleImage(with data: TitleImage) {
        movie = data
    }
    
}

extension PreviewViewController: CustomTopBarUIViewDelegate {
    func customTopBarUIViewDidTapPopBack() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
}
