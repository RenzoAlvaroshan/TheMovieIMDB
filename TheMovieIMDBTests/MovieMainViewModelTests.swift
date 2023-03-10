//
//  MovieMainViewModelTests.swift
//  TheMovieIMDBTests
//
//  Created by Renzo Alvaroshan on 10/03/23.
//

import XCTest
import RxSwift
@testable import TheMovieIMDB

class MovieMainViewModelTests: XCTestCase {
	
	var viewModel: MovieMainViewModel!
	var mockNetworkService: MockNetworkService!
	var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()
		
		mockNetworkService = MockNetworkService()
		viewModel = MovieMainViewModel(networkService: mockNetworkService)
		disposeBag = DisposeBag()
	}
	
	override func tearDown() {
		viewModel = nil
		mockNetworkService = nil
		disposeBag = nil
		super.tearDown()
	}

	func testDiscoverMovies_Success() {
		// Given
		let movie1 = getMockMovie1()
		let movie2 = getMockMovie2()
		
		// When
		mockNetworkService.mockDiscoverMovies(context: .successDiscoverMovies(result: [movie1, movie2]))
		viewModel.loadMoreMovies()
		
		// Then
		viewModel.movies.asObservable()
			.subscribe { movies in
				guard let responseMovie1 = movies.element?[0] else { return }
				XCTAssertEqual(responseMovie1, movie1)
			}.disposed(by: disposeBag)
	}
	
	func testDiscoverMovies_Failure() {
		// When
		mockNetworkService.mockDiscoverMovies(context: .error)
		viewModel.loadMoreMovies()
		
		// Then
		viewModel.movies.asObservable()
			.subscribe { movies in
				XCTAssertEqual(movies, [])
			}.disposed(by: disposeBag)
	}
}

private func getMockMovie1() -> Movie {
	
	return Movie(id: 1, mediaType: "mockMedia1", originalName: "mockName1", originalTitle: "mockTitle1", posterPath: "mockPath1", overview: "mockOverview1", releaseDate: "mockDate1")
}

private func getMockMovie2() -> Movie {
	
	return Movie(id: 2, mediaType: "mockMedia2", originalName: "mockName2", originalTitle: "mockTitle2", posterPath: "mockPath2", overview: "mockOverview2", releaseDate: "mockDate2")
}
