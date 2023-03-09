//
//  MovieInfoViewModel.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Foundation
import RxSwift
import RxRelay

final class MovieInfoViewModel {
	
	private let networkService: NetworkServiceProtocol
	
	private let disposeBag = DisposeBag()
	
	let userReviews: BehaviorRelay<[UserReview]> = BehaviorRelay<[UserReview]>(value: [])
	
	// observable video property
	let video = BehaviorSubject<VideoElement?>(value: nil)
	
	init(networkService: NetworkServiceProtocol = NetworkService()) {
		self.networkService = networkService
	}
	
	func searchVideo(for movieTitle: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
		networkService.searchVideo(query: movieTitle + "trailer") { result in
			completion(result)
		}
	}
	
	func getMovieReviews(for movieId: Int) {
		networkService.getMovieReviews(movieId: movieId) { result in
			switch result {
			case .success(let reviews):
				self.userReviews.accept(reviews)
			case .failure(let error):
				print("Failed to getMovieReviews: \(error)")
			}
		}
	}
}
