//
//  API.swift
//  boiflix
//
//  Created by Duy Ha on 19/12/2023.
//

import Foundation

struct Constants {
    static let API_KEY = "8bc517e633a313e2ec9ec8a05558f7cf"
    static let BASE_URL = "https://api.themoviedb.org"
    static let NETWORK_IMAGE = "https://image.tmdb.org/t/p/w500"
    static let YTB_API_KEY = "AIzaSyAJbkf2CicYCPWYP0aE4NlwveWgqJc1DTg"
    static let YTB_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let YTB_EMBED_URL = "https://www.youtube.com/embed"
}

enum APIError: Error {
    case failedTogetData
}

class API {
    static let shared = API()
    
    func getTrendingMovies(completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getTVShows(completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getUpcomings(completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getPopulars(completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY)&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")
            else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func searchKeywords(key query: String ,completion: @escaping (Result<[TitleImage], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.BASE_URL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)")
            else { return }
                
        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let rs = try JSONDecoder().decode(TitleImagesResponse.self, from: data)
                completion(.success(rs.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getYTBMovie(key query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YTB_BASE_URL)q=\(query)&key=\(Constants.YTB_API_KEY)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)) { data, _, error in
            guard let data = data, error == nil else {return}

            do {
                let rs = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                completion(.success(rs.items.count > 0 ? rs.items[0] : VideoElement(id: IdVideoElement(kind: "nil", videoId: "nil"))))
            } catch {
                print("URL: \(url)")
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
}
