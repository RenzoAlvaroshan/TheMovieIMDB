//
//  MockNetworkService.swift
//  TheMovieIMDBTests
//
//  Created by Renzo Alvaroshan on 10/03/23.
//

@testable import TheMovieIMDB
import RxSwift
import RxRelay

enum DiscoverMoviesContext {
	case successDiscoverMovies(result: [Movie])
	case error
}

enum SearchVideoContext {
	case successSearchVideo(result: VideoElement)
	case error
}

enum GetMovieReviewsContext {
	case successGetMovieReviews(result: [UserReview])
	case error
}

final class MockNetworkService {
	
	var discoverMovies: BehaviorRelay<[Movie]?> = BehaviorRelay<[Movie]?>(value: nil)
	var searchVideo: BehaviorRelay<VideoElement?> = BehaviorRelay<VideoElement?>(value: nil)
	var getMovieReviews: BehaviorRelay<[UserReview]?> = BehaviorRelay<[UserReview]?>(value: nil)
	var errorResult: BehaviorRelay<Error?> = BehaviorRelay<Error?>(value: nil)
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	func mockDiscoverMovies(context: DiscoverMoviesContext) {
		switch context {
		case .successDiscoverMovies(let result):
			discoverMovies.accept(result)
		case .error:
			errorResult.accept(NSError())
		}
	}
	
	func mockSearchVideo(context: SearchVideoContext) {
		switch context {
		case .successSearchVideo(let result):
			searchVideo.accept(result)
		case .error:
			errorResult.accept(NSError())
		}
	}
	
	func mockGetMovieReviews(context: GetMovieReviewsContext) {
		switch context {
		case .successGetMovieReviews(let result):
			getMovieReviews.accept(result)
		case .error:
			errorResult.accept(NSError())
		}
	}
}

extension MockNetworkService: NetworkServiceProtocol {
	
	func discoverMovies(page: Int, completion: @escaping (Result<[TheMovieIMDB.Movie], Error>) -> Void) {
		
		if let movies = discoverMovies.value {
			completion(.success(movies))
		} else if let errorValue = errorResult.value {
			completion(.failure(errorValue))
		}
	}
	
	func searchVideo(query: String, completion: @escaping (Result<TheMovieIMDB.VideoElement, Error>) -> Void) {
		
		if let video = searchVideo.value {
			completion(.success(video))
		} else if let errorValue = errorResult.value {
			completion(.failure(errorValue))
		}
	}
	
	func getMovieReviews(movieId: Int, completion: @escaping (Result<[TheMovieIMDB.UserReview], Error>) -> Void) {
		
		if let reviews = getMovieReviews.value {
			completion(.success(reviews))
		} else if let errorValue = errorResult.value {
			completion(.failure(errorValue))
		}
	}
}
