//
//  SearchViewController.swift
//  boiflix
//
//  Created by Duy Ha on 17/12/2023.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private var movies: [TitleImage] = [TitleImage]()
    
    //Watch schedule dispatch work
    private var searchWorkItem: DispatchWorkItem?
    
    private let discoverTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //Set navigation title
        title = "Search"
        
        //configure navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController

        //configure Discover Table
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
   
        //get data
        fetchData()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchData() {
        API.shared.getDiscoverMovies { [weak self] rs in
            switch rs {
            case .success(let movies):
                self?.movies = movies
                
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath) as? BasicTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        
        let item = movies[indexPath.row]
        let params = BasicViewModel(titleName: (item.original_title ?? item.original_name) ?? "", pathURL: item.poster_path ?? "")
        cell.configure(with: params)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    //Update search results
    func updateSearchResults(for searchController: UISearchController) {
        //Cancel all previous works
        searchWorkItem?.cancel()
        
        let searchText = searchController.searchBar.text
        
        guard let query = searchText,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        resultController.delegate = self
        
        //Add new Work schedule
        let workItem = DispatchWorkItem {
                   API.shared.searchKeywords(key: query) { rs in
                       DispatchQueue.main.async {
                           switch rs {
                           case .success(let movies):
                               resultController.onSearchResults(with: movies)
                               resultController.onReloadCollectionData()

                           case .failure(let error):
                               print(error.localizedDescription)
                           }
                       }
                   }
               }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: workItem)

        //Stored new Work schedule
        searchWorkItem = workItem
    }
    
    //On press item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showLoading()
        
        let item = movies[indexPath.row]
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

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultViewControllerDidTap(viewcontroller: PreviewViewController) {
        DispatchQueue.main.async {[weak self] in
            viewcontroller.modalPresentationStyle = .fullScreen
            self?.present(viewcontroller, animated: true)
        }
    }
    
    
}
