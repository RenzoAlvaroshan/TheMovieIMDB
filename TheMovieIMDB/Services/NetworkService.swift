//
//  NetworkService.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Moya

protocol NetworkServiceProtocol {
	func discoverMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
	
	private let provider: MoyaProvider<MovieAPI> = MoyaProvider<MovieAPI>()
	
	func discoverMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
		
		provider.request(.discoverMovies(page: page)) { result in
			switch result {
			case .success(let response):
				do {
					let decoded = try JSONDecoder().decode(MovieResponse.self, from: response.data)
					completion(.success(decoded.results))
				} catch {
					completion(.failure(error))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
