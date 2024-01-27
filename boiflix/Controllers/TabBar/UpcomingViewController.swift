//
//  UpcomingViewController.swift
//  boiflix
//
//  Created by Duy Ha on 17/12/2023.
//

import UIKit

class UpcomingViewController: BaseViewController {
    
    private let upcomingTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    private var upcomings: [TitleImage] = [TitleImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //Set navigation title
        title = "Upcoming"
        
        //configure navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        //Add TableView
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        //get data
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchData() {
        API.shared.getUpcomings { [weak self] rs in
            switch rs {
            case .success(let upcomings):
                self?.upcomings = upcomings
                
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath) as? BasicTableViewCell else {
            return UITableViewCell()
        }
        
        let item = upcomings[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.configure(with: BasicViewModel(titleName: (item.original_name ?? item.original_title) ?? "", pathURL: item.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showLoading()
        
        let item = upcomings[indexPath.row]
        guard let titleName = item.original_name ?? item.original_title else {
            hideLoading()
            popUpToastFailed()
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
                    vc.modalPresentationStyle = .fullScreen
                    
                    self?.present(vc, animated: true)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.hideLoading()
                    self?.popUpToastFailed()
                }
                print(error.localizedDescription)
            }
        }
    }
    
}
