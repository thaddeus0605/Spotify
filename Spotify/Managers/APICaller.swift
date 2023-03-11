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
