//
//  CollectionViewTableViewCell.swift
//  boiflix
//
//  Created by Duy Ha on 18/12/2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTap(cellItem: TitleImage)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier: String = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var contentList: [TitleImage] = [TitleImage]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150.0, height: 200.0)
        layout.sectionInset = .init(top: 0, left: 5.0, bottom: 0, right: 10.0)
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout )
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with contentList: [TitleImage]) {
        self.contentList = contentList
        
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func onPressPlayAt(index indexPath: IndexPath) {
        let selectedItem = contentList[indexPath.row]
        delegate?.collectionViewTableViewCellDidTap(cellItem: selectedItem)
    }
    
    private func onPressDownloadAt(index indexPath: IndexPath) {
        var data: [TitleImage] = StorageManager.shared.loadTitleImages()
        
        let selectedItem = contentList[indexPath.row]
        let isMovieExist = data.contains { $0.id == selectedItem.id }

        guard !isMovieExist else {
            popUpToast(title: "Failed", subTitle: "This movie already exists in the download section")?.show()
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] _ in
            data.append(selectedItem)
            StorageManager.shared.saveTitleImages(data)
            
            self?.popUpToast(title: "Successful", subTitle: "Added movie to download section")?.show()
        }
    }
    

}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Number of Item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }
    
    // Configure Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        
        guard let endPath = contentList[indexPath.row].poster_path else { return UICollectionViewCell() }
        
        cell.configure(with: endPath)
        
        return cell
    }
    
    //On Selected Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = contentList[indexPath.row]
        delegate?.collectionViewTableViewCellDidTap(cellItem: item)
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
          let config = UIContextMenuConfiguration(
              identifier: nil,
              previewProvider: nil) { _ in
                let playAction = UIAction(title: "Play", state: .off) { [weak self] _ in
                    self?.onPressPlayAt(index: indexPath)
                }
                  
                let downloadAction = UIAction(title: "Download", state: .off) { [weak self] _ in
                    self?.onPressDownloadAt(index: indexPath)
                }
                  
                return UIMenu(title: "", options: .displayInline, children: [playAction, downloadAction])
              }
          
          return config
    }
    
}
