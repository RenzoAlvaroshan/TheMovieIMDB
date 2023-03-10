//
//  MovieMainViewModel.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Foundation
import RxRelay

final class MovieMainViewModel {
	
	// MARK: - Properties
	
	weak var delegate: MovieMainViewControllerDelegate?
	
	let movies: BehaviorRelay<[Movie]> = BehaviorRelay<[Movie]>(value: [])

//	let adapter: ListAdapter? = nil
	
	private let networkService: NetworkServiceProtocol
	private var currentPage = 1

	// MARK: - Initialization

	init(networkService: NetworkServiceProtocol = NetworkService()) {
		self.networkService = networkService
	}

	// MARK: - Public methods

	func loadMoreMovies() {
		
		let nextPage = currentPage + 1
		
		networkService.discoverMovies(page: nextPage) { [weak self] result in
			
			guard let self = self else { return }
			
			switch result {
			case .success(let movies):
				self.movies.accept(self.movies.value + movies)
				self.currentPage = nextPage
			case .failure(let error):
				print("Failed to load more movies: \(error)")
				self.delegate?.showError(error)
			}
		}
	}
}
