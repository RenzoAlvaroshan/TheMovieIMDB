//
//  MovieInfoViewModelTests.swift
//  TheMovieIMDBTests
//
//  Created by Renzo Alvaroshan on 10/03/23.
//

import XCTest
import RxSwift
@testable import TheMovieIMDB

class MovieInfoViewModelTests: XCTestCase {
	
	var viewModel: MovieInfoViewModel!
	var mockNetworkService: MockNetworkService!
	var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()
		
		mockNetworkService = MockNetworkService()
		viewModel = MovieInfoViewModel(networkService: mockNetworkService)
		disposeBag = DisposeBag()
	}
	
	override func tearDown() {
		viewModel = nil
		mockNetworkService = nil
		disposeBag = nil
		super.tearDown()
	}

	func testSearchVideo_Success() {
		// Given
		let mockMovieTitle: String = "mockTitle"
		let mockIdVideoElement: IdVideoElement = IdVideoElement(kind: "mockKind", videoId: "mockId")
		let mockVideoElement: VideoElement = VideoElement(id: mockIdVideoElement)
		
		// When
		mockNetworkService.mockSearchVideo(context: .successSearchVideo(result: mockVideoElement))
		viewModel.searchVideo(for: mockMovieTitle) { result in
			switch result {
			case .success(let response):
				let videoElement = response
				XCTAssertEqual(videoElement, mockVideoElement)
			case .failure(_):
				break
			}
		}
	}
	
	func testGetMovieReviews_Success() {
		// Given
		let mockId: Int = 1
		let mockUserReview: UserReview = UserReview(author: "mockAuthor", content: "mockContent")
		
		// When
		mockNetworkService.mockGetMovieReviews(context: .successGetMovieReviews(result: [mockUserReview]))
		viewModel.getMovieReviews(for: mockId)
		
		// Then
		viewModel.userReviews.asObservable()
			.subscribe { reviews in
				let userReviews = reviews.element
				XCTAssertEqual(userReviews?[0], mockUserReview)
			}.disposed(by: disposeBag)
	}
	
	func testGetMovieReviews_Failure() {
		// Given
		let mockId: Int = 1
		
		// When
		mockNetworkService.mockGetMovieReviews(context: .error)
		viewModel.getMovieReviews(for: mockId)
		
		// Then
		viewModel.userReviews.asObservable()
			.subscribe { reviews in
				let userReviews = reviews.element
				XCTAssertEqual(userReviews, [])
			}.disposed(by: disposeBag)
	}
}

