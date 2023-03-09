//
//  MovieMainViewController.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import UIKit
import SnapKit
import RxSwift

final class MovieMainViewController: UIViewController {
	
	// MARK: - Properties
	
	private var isLoading: Bool = false
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	private lazy var collectionView: UICollectionView = {
		let layout = PinterestLayout()
		layout.contentPadding = .init(horizontal: 8, vertical: 8)
		layout.cellsPadding = .init(horizontal: 8, vertical: 8)
		layout.columnsCount = 2
		layout.delegate = self

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

extension MovieMainViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let movie = viewModel.movies.value[indexPath.item]
		
		guard let movieTitle = movie.originalTitle,
			  let movieOverview = movie.overview else { return }
		
		DispatchQueue.main.async {
			let infoVC = MovieInfoViewController(viewModel: self.infoViewModel)
			infoVC.loadVideo(for: movieTitle)
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
}

// MARK: - PinterestLayoutDelegate

extension MovieMainViewController: PinterestLayoutDelegate {
	
	func cellSize(indexPath: IndexPath) -> CGSize {
		
		let width = (collectionView.frame.width / 2) - 10
		
		return CGSize(width: width, height: 200)
	}
}
