//
//  HomeViewController.swift
//  boiflix
//
//  Created by Duy Ha on 17/12/2023.
//

import UIKit

enum Sections: Int {
    case Movies = 0
    case TV = 1
    case Populars = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: BaseViewController {
    
    let sectionTitle: [String] = ["Most Rated Movies", "TV Shows", "Popular", "Upcoming Movies", "Top Rated"]
    
    //New Feed Table View
    private let feedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private var headerView: HomeHeaderUIView?
    private var footerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(feedTable)
      
        //Add configures for TableView
        headerView = HomeHeaderUIView(frame: .init(origin: .zero, size: .init(width: view.bounds.width, height: view.bounds.height * 0.5)))
        footerView = UIView(frame: .init(origin: .zero, size: .init(width: view.bounds.width, height: 25.0)))
        feedTable.tableHeaderView = headerView
        feedTable.tableFooterView = footerView
        feedTable.backgroundColor = .systemBackground
        feedTable.separatorStyle = .none
        feedTable.showsVerticalScrollIndicator = false
        
        //set delegate & data source
        feedTable.delegate = self
        feedTable.dataSource = self
        headerView?.delegate = self
        
        //configure
        configueNavBar()
        configureHomeHeaderView()
    }
      
    // Customize subview base on Super View
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTable.frame = view.bounds
    }
    
    private func configueNavBar() {
        let leftInset = (UIScreen.main.bounds.width / 4.3)
            
        var image = UIImage(named: "boiflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        image = image?.withAlignmentRectInsets(.init(top: 0, left: -leftInset, bottom: 0, right: 0))
        
        navigationItem.leftBarButtonItem = .init(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .init(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: .init(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureHomeHeaderView() {
        API.shared.getTrendingMovies { [weak self] rs in
            switch rs {
            case .success(let movies):
                guard let randomMovie = movies.randomElement(), movies.count > 0 else { return }
                self?.headerView?.configure(withMovie: randomMovie)
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    private func showToastError() {
        popUpToast(title: "Failed", subTitle: "Something when wrong please try again later")?.show()
    }
}

//extends to delegate Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // Number of Rows in One Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Configure Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        //customize cell
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.Movies.rawValue:
            API.shared.getTrendingMovies { rs in
                switch rs {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TV.rawValue:
            API.shared.getTVShows { rs in
                switch rs {
                case .success(let tvShows):
                    cell.configure(with: tvShows)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Populars.rawValue:
            API.shared.getPopulars { rs in
                switch rs {
                case .success(let populars):
                    cell.configure(with: populars)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            API.shared.getUpcomings { rs in
                switch rs {
                case .success(let upcomings):
                    cell.configure(with: upcomings)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            API.shared.getTopRated { rs in
                switch rs {
                case .success(let topRateds):
                    cell.configure(with: topRateds)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default: return cell
            
        }
        
        return cell
    }
    
    // Height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //Height of Header in each Section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    // View of Header in each Section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: section != 0 ? 45.0 : 30.0))

        let label = UILabel(frame: CGRect(x: header.bounds.origin.x + 20.0, y: 0, width: header.bounds.width * 0.6 , height: header.bounds.height))
        label.text = sectionTitle[section].capitalizeFirstLetter()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label

        header.addSubview(label)

        return header
    }

    // Navigation Bar will not stick on safeview when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section].capitalizeFirstLetter()
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else {return}
//
//        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.frame = .init(x: header.bounds.origin.x + 0.0, y: header.bounds.origin.y, width: tableView.bounds.width, height: header.bounds.height)
//        header.textLabel?.textColor = .label
//    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate, HomeHeaderUIViewDelegate {
    private func pushToPreviewViewController(item: TitleImage) {
        showLoading()
        guard let titleName = item.original_name ?? item.original_title else {
            hideLoading()
            popUpToastFailed()
            return
        }

        API.shared.getYTBMovie(key: titleName + " trailer") { [weak self] rs in
            switch rs {
            case .success(let video):
                DispatchQueue.main.async {
                    let vc = PreviewViewController()
                    let vm = PreviewViewModel(title: titleName, titleOverView: item.overview ?? "", youtubeView: video)
                    vc.configure(with: vm)
                    vc.addTitleImage(with: item)
                    vc.modalPresentationStyle = .fullScreen
                    
                    self?.hideLoading()
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
    
    func collectionViewTableViewCellDidTap(cellItem: TitleImage) {
        pushToPreviewViewController(item: cellItem)
    }
    
    func homeHeaderUIView(didTapPlay item: TitleImage) {
        pushToPreviewViewController(item: item)
    }
    
    func homeHeaderUIView(didTapDownload isTapped: Bool) {
        guard isTapped else {
            showToastError()
            return
        }
        
        popUpToast(title: "Successful", subTitle: "Added movie to download section")?.show()
    }

}
