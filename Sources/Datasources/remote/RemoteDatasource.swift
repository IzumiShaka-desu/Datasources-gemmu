//
//  RemoteDatasource.swift
//  Gemmu
//
//  Created by Akashaka on 16/02/22.
//

import Common
import Home
import Search
import Detail
import Foundation
import Alamofire
import Combine

public protocol RemoteDataSourceProtocol: AnyObject {
  func getGames(target: String?) -> AnyPublisher<GamesResponse, Error>
  func searchGames(for query: String) -> AnyPublisher<GamesSearchResponse, Error>
  func getDetailGame(for id: Int) -> AnyPublisher<GameDetailResponse, Error>
}
public final class RemoteDataSource: NSObject {

  private override init() { }

public  static let sharedInstance: RemoteDataSource =  RemoteDataSource()

}
extension RemoteDataSource: RemoteDataSourceProtocol {
public  func getGames(target: String? = nil) -> AnyPublisher<GamesResponse, Error> {
    return Future<GamesResponse, Error> { completion in
      if let url = API.buildUrl(endpoint: .games) {
        AF.request(target ?? url)
          .validate()
          .responseDecodable(of: GamesResponse.self) { response in
            switch response.result {
            case .success(let value):
              completion(.success(value))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
public  func searchGames(for query: String) -> AnyPublisher<GamesSearchResponse, Error> {
    return Future<GamesSearchResponse, Error> { completion in
      if let url = API.buildUrl(endpoint: .games, args: ["search": query]) {
        AF.request(url)
          .validate()
          .responseDecodable(of: GamesSearchResponse.self) { response in
            switch response.result {
            case .success(let value):
              completion(.success(value))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
public  func getDetailGame(for id: Int) -> AnyPublisher<GameDetailResponse, Error> {
    return Future<GameDetailResponse, Error> { completion in
      if let url = API.buildUrl(endpoint: .games, param: "/\(id)") {
        AF.request(url)
          .validate()
          .responseDecodable(of: GameDetailResponse.self) { response in
            switch response.result {
            case .success(let value):
              completion(.success(value))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
}
