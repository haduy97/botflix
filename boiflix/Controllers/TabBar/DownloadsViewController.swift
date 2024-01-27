//
//  DownloadsViewController.swift
//  boiflix
//
//  Created by Duy Ha on 17/12/2023.
//

import UIKit

class DownloadsViewController: BaseViewController {
    
    private var downloads: [TitleImage] = [TitleImage]()
    
    private let downloadTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let moviesStorage: [TitleImage] = StorageManager.shared.loadTitleImages()
        downloads = moviesStorage
        downloadTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create subview
        view.addSubview(downloadTable)
        
        //Set navigation title
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        //Set delegate & datasource for table
        downloadTable.delegate = self
        downloadTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    private func onDeleteClick(_ indexPath: IndexPath) {
        downloads.remove(at: indexPath.row)
        downloadTable.deleteRows(at: [indexPath], with: .right)
        
        popUpToast(title: "Successful", subTitle: "The movie has been removed", dismissTime: 2.2 )?.show()
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            StorageManager.shared.saveTitleImages(self?.downloads ?? [])
        }
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath) as? BasicTableViewCell else {
            let noCell = UITableViewCell()
            noCell.backgroundColor = .clear
            return UITableViewCell()
        }
        
        let item = downloads[indexPath.row]
        cell.configure(with: BasicViewModel(titleName: item.original_name ?? item.original_title ?? "", pathURL: item.poster_path ?? ""))
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, _, complition) in
            self?.onDeleteClick(indexPath)
            complition(true)
        }
        delete.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
    
    
}
