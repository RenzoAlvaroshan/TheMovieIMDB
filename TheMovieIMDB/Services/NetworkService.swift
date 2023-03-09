//
//  NetworkService.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Moya

protocol NetworkServiceProtocol {
	func discoverMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
	func searchVideo(query: String, completion: @escaping (Result<VideoElement, Error>) -> Void)
	func getMovieReviews(movieId: Int, completion: @escaping (Result<[UserReview], Error>) -> Void)
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
	
	func searchVideo(query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
		
		provider.request(.searchMovie(query: query)) { result in
			switch result {
			case .success(let response):
				do {
					let decoded = try JSONDecoder().decode(YoutubeSearchResponse.self, from: response.data)
					completion(.success(decoded.items[0]))
				} catch {
					completion(.failure(error))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func getMovieReviews(movieId: Int, completion: @escaping (Result<[UserReview], Error>) -> Void) {
		
		provider.request(.getMovieReviews(movieId: movieId)) { result in
			switch result {
			case .success(let response):
				do {
					let decoded = try JSONDecoder().decode(UserReviewsResponse.self, from: response.data)
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
