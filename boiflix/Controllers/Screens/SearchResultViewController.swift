//
//  SearchResultViewController.swift
//  boiflix
//
//  Created by Duy Ha on 22/12/2023.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTap(viewcontroller: PreviewViewController)
}

class SearchResultViewController: BaseViewController {
    
    private var searchResults: [TitleImage] = [TitleImage]()
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    private let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 3 - 4, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //confignure main cell view
        view.backgroundColor = .systemBackground
        view.addSubview(resultsCollectionView)
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Collection View with full size
        resultsCollectionView.frame = view.bounds
    }
    
    public func onSearchResults(with results: [TitleImage]) {
        guard results.count > 0 else { return }
        searchResults = results
    }
    
    public func onReloadCollectionData() {
        resultsCollectionView.reloadData()
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else {
                return UICollectionViewCell()
            }
        cell.layer.cornerRadius = 2.0
        cell.layer.masksToBounds = true
    
        
        let item = searchResults[indexPath.row]
        cell.configure(with: item.poster_path ?? "")
        
        
        return cell
    }
    
    
    //On press collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        showLoading()
        popUpToastFailed()
        
        let item = searchResults[indexPath.row]
        guard let titleName = item.original_name ?? item.original_title else {
            hideLoading()
            return
        }
        
        API.shared.getYTBMovie(key: titleName + " trailer") { [weak self] rs in
            switch rs {
            case .success(let video):
                let vm = PreviewViewModel(title: titleName, titleOverView: item.overview ?? "", youtubeView: video)
                
                DispatchQueue.main.async {
                    self?.hideLoading()
                    
                    let vc = PreviewViewController()
                    vc.configure(with: vm)
                    vc.addTitleImage(with: item)
                    
                    self?.delegate?.searchResultViewControllerDidTap(viewcontroller: vc)
                }
                
            case .failure(let error):
                self?.hideLoading()
                self?.popUpToastFailed()
                print(error.localizedDescription)
            }
        }
    }
    
    
}
