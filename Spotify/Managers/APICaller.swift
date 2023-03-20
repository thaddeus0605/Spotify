//
//  APICaller.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/5/23.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    private init() { }
    
    struct Constants {
        static let baseUrl = "https://api.spotify.com/v1/"
    }
    
    enum APIError:Error {
        case failedToGetData
    }
    
    
    
    //MARK: GET USER DATA
    
    //get current user profile and decode json
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "me"),
            type: .GET)
        { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: GET BROWSING DATA
    
    //get new releases
    public func getNewReleases(completion: @escaping (Result<NewReleaseResponse, Error>) -> Void) {
        creatRequest(with: URL(string: Constants.baseUrl + "browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // get featured playlists
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturePlaylistResponse, Error>) -> Void) {
        creatRequest(with: URL(string: Constants.baseUrl + "browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturePlaylistResponse.self, from: data)
                    completion(.success(result))
                   
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
//    //get recommendations
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        creatRequest(
            with: URL(string: Constants.baseUrl + "recommendations?limit=40&seed_genres=\(seeds)"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                   completion(.success(result))
                  
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //get available genre seeds
    public func getRecommendedGenres(completion: @escaping (Result<ReccommendedGenresResponse, Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "recommendations/available-genre-seeds"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(ReccommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: GET ALBUM DATA
    public func getAlbumDetails(album: Album, completion: @escaping (Result<AlbumDetailsResponses, Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "albums/" + album.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let data = try JSONDecoder().decode(AlbumDetailsResponses.self, from: data)
                    print(data)
                    completion(.success(data))
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(json)
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: GET PLAYLIST DATA
    
    public func getPlaylistDetails(playlist: Playlist, completion: @escaping (Result<PlaylistDetailResponse, Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "playlists/" + playlist.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let data = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
//                    print(data)
                    completion(.success(data))
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(json)
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    // MARK: - Private
    
    enum HTTPMethod:String {
        case GET
        case POST
    }
    //creates requests to spotify API
    private func creatRequest(with url: URL?,
                              type: HTTPMethod,
                              completion: @escaping (URLRequest) -> Void)
    {
        AuthManager.shared.withValidToken { token  in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(request)
        }
    }
}
