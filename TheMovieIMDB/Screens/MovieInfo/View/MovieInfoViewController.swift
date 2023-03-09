//
//  MovieInfoViewController.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import UIKit
import SnapKit
import WebKit
import RxSwift

final class MovieInfoViewController: UIViewController {
	
	// MARK: - Properties
	
	private let webView: WKWebView = WKWebView()
	
	private let movieOverviewTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.label
		label.text = "Movie Overview"
		return label
	}()
	
	private let movieOverviewContentLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.textColor = UIColor.label
		label.text = "Failed to get the movie overview"
		return label
	}()
	
	private let userReviewsTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor.label
		label.text = "User Reviews"
		return label
	}()
	
	private lazy var userReviewsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.showsVerticalScrollIndicator = false
		tableView.backgroundColor = .clear
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.register(UserReviewCell.self, forCellReuseIdentifier: UserReviewCell.reuseIdentifier)
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()
	
	private let viewModel: MovieInfoViewModel
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - Initialization
	
	init(viewModel: MovieInfoViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		view.backgroundColor = .systemBackground
		configureWebView()
		configureMovieOverview()
		configureUserReviews()
		observeViewModel()
	}
	
	// MARK: - Private Methods
	
	private func configureWebView() {
		view.addSubview(webView)
		webView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(300)
		}
	}
	
	private func configureMovieOverview() {
		
		view.addSubview(movieOverviewTitleLabel)
		movieOverviewTitleLabel.snp.makeConstraints { make in
			make.top.equalTo(webView.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().inset(8)
		}
		
		view.addSubview(movieOverviewContentLabel)
		movieOverviewContentLabel.snp.makeConstraints { make in
			make.top.equalTo(movieOverviewTitleLabel.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().inset(8)
		}
	}
	
	private func configureUserReviews() {
		view.addSubview(userReviewsTitleLabel)
		userReviewsTitleLabel.snp.makeConstraints { make in
			make.top.equalTo(movieOverviewContentLabel.snp.bottom).offset(16)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().inset(8)
		}
		
		view.addSubview(userReviewsTableView)
		userReviewsTableView.snp.makeConstraints { make in
			make.top.equalTo(userReviewsTitleLabel.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
		}
	}
	
	private func observeViewModel() {
		viewModel.userReviews.asObservable()
			.subscribe { _ in
				DispatchQueue.main.async {
					self.userReviewsTableView.reloadData()
				}
			}.disposed(by: disposeBag)
	}
	
	// MARK: - Public Methods
	
	func loadVideo(for movieTitle: String) {
		viewModel.searchVideo(for: movieTitle) { [weak self] result in
			switch result {
			case .success(let video):
				guard let url = URL(string: "https://www.youtube.com/embed/\(video.id.videoId)") else {
					return
				}
				self?.webView.load(URLRequest(url: url))
			case .failure(let error):
				print("Failed to load search video: \(error)")
			}
		}
	}
	
	func getMovieReviews(for movieId: Int) {
		viewModel.getMovieReviews(for: movieId)
	}
	
	func configureLabel(overview: String) {
		movieOverviewContentLabel.text = overview
	}
}

// MARK: - UITableViewDataSource

extension MovieInfoViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.userReviews.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: UserReviewCell.reuseIdentifier, for: indexPath) as? UserReviewCell else { return UITableViewCell() }
		
		let userReview = viewModel.userReviews.value[indexPath.row]
		
		cell.configure(with: userReview)
		
		return cell
	}
}

// MARK: - UITableViewDelegate

extension MovieInfoViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		//		let userReview = viewModel.userReviews.value[indexPath.row]
		//		guard let url = URL(string: userReview.) else { return }
		//		UIApplication.shared.open(url)
	}
}
