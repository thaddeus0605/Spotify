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
    
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "me/albums"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data)
                    completion(.success(result.items.compactMap({ $0.album })))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "me/albums?ids=\(album.id)"),
            type: .PUT
        ) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                print(code)
                completion(code == 200)
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
    
    
    public func getCurrentUserPlayists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "me/playlists/?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //                    print(json)
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    completion(.success(result.items))
                    
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self ]result in
            switch result {
            case .success(let profile):
                let urlString = Constants.baseUrl + "users/\(profile.id)/playlists"
                
                self?.creatRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data, error == nil else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("Created")
                                completion(true)
                            } else {
                                completion(false)
                            }
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func addTrackToPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "playlists/\(playlist.id)/tracks"),
            type: .POST
        ) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments  )
                    if let response = result as? [String: Any],
                       response["snapshot_id"] as? String != nil {
                        completion(true)
                    }
                    else {
                        
                        completion(false)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
                
            }
            task.resume()
            
        }
    }
    
    public func removeTrackFromPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "playlists/\(playlist.id)/tracks"),
            type: .DELETE
        ) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments  )
                    if let response = result as? [String: Any],
                       response["snapshot_id"] as? String != nil {
                        completion(true)
                    }
                    else {
                        
                        completion(false)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
                
            }
            task.resume()
            
        }
    }
    
    //MARK: - Get Search Categories
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "browse/categories?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CatergoriesResponse.self, from: data)
                    print(result.categories.items)
                    completion(.success(result.categories.items))
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
    
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "browse/categories/\(category.id)/playlists?limit=20"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturePlaylistResponse.self, from: data)
                    let playlist = result.playlists.items
                    completion(.success(playlist))
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
    
    //MARK: - SEARCH API
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        creatRequest(
            with: URL(string: Constants.baseUrl + "search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //                    print(json)
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResult.track(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ SearchResult.artist(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ SearchResult.album(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ SearchResult.playlist(model: $0) }))
                    
                    completion(.success(searchResults))
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
        case PUT
        case DELETE
    }
    //creates requests to spotify API
    private func creatRequest(with url: URL?,
                              type: HTTPMethod,
                              completion: @escaping (URLRequest) -> Void
    )
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
