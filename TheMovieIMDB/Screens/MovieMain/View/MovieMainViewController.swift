//
//  MovieMainViewController.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import UIKit
import SnapKit
import RxSwift
import SkeletonView

protocol MovieMainViewControllerDelegate: AnyObject {
	func showError(_ error: Error)
}

final class MovieMainViewController: UIViewController {
	
	// MARK: - Properties
	
	private var isLoading: Bool = false
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .systemBackground
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: MovieGridCell.reuseIdentifier)
		collectionView.scrollsToTop = true

		return collectionView
	}()
	
	private let viewModel: MovieMainViewModel
	private let infoViewModel: MovieInfoViewModel
	
	// MARK: - Initialization
	
	init(viewModel: MovieMainViewModel, infoViewModel: MovieInfoViewModel) {
		self.viewModel = viewModel
		self.infoViewModel = infoViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		configureCollectionView()
		observeViewModel()
		loadMoreMovies()
		viewModel.delegate = self
	}
	
	// MARK: - Private Methods
	
	func reloadCollectionView() {
		DispatchQueue.main.async { [weak self] in
			self?.collectionView.reloadData()
		}
	}
	
	private func configureCollectionView() {
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.equalToSuperview().offset(4)
			make.right.equalToSuperview().offset(-4)
		}
	}
	
	private func observeViewModel() {
		viewModel.movies.asObservable()
			.subscribe { [weak self] _ in
				guard let self = self else { return }
				self.reloadCollectionView()
			}.disposed(by: disposeBag)
	}
	
	private func loadMoreMovies() {
		viewModel.loadMoreMovies()
	}
}

// MARK: - MovieMainViewControllerDelegate

extension MovieMainViewController: MovieMainViewControllerDelegate {
	func showError(_ error: Error) {
		let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			self.loadMoreMovies()
		}))
		present(alert, animated: true)
	}
}

// MARK: - UICollectionViewDataSource

extension MovieMainViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.movies.value.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGridCell.reuseIdentifier, for: indexPath) as? MovieGridCell else { return UICollectionViewCell() }
		
		let movie = viewModel.movies.value[indexPath.item]
		
		cell.configure(with: movie)
		
		return cell
	}
}

// MARK: - UICollectionViewDelegate

extension MovieMainViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let movie = viewModel.movies.value[indexPath.item]
		
		guard let movieTitle = movie.originalTitle,
			  let movieOverview = movie.overview else { return }
		
		DispatchQueue.main.async {
			let infoVC = MovieInfoViewController(viewModel: self.infoViewModel)
			infoVC.movieTitle = movieTitle
			infoVC.configureLabel(overview: movieOverview)
			infoVC.getMovieReviews(for: movie.id)
			self.navigationController?.pushViewController(infoVC, animated: true)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		let lastIndex = collectionView.numberOfItems(inSection: 0) - 1
		
		if indexPath.item == lastIndex && !isLoading {
			isLoading = true
			loadMoreMovies()
			isLoading = false
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let width = (collectionView.frame.width / 2) - 10
		
		return CGSize(width: width, height: 250)
	}
}
