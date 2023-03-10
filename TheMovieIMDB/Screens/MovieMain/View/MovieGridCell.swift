//
//  MovieGridCell.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 08/03/23.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class MovieGridCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	static let reuseIdentifier = "MovieGridCell"
	
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.isSkeletonable = true
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureCell()
	}
	
	override func prepareForReuse() {
		imageView.image = nil
		imageView.isSkeletonable = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Private Methods
	
	private func configureCell() {
		addSubview(imageView)
		addSubview(titleLabel)
		imageView.snp.makeConstraints { make in
			make.centerX.equalTo(snp.centerX)
			make.leading.equalTo(snp.leading).offset(16)
			make.trailing.equalTo(snp.trailing).inset(16)
			make.height.equalTo(200)
		}
		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(snp.leading).offset(10)
			make.trailing.equalTo(snp.trailing).inset(10)
			make.top.equalTo(imageView.snp.bottom).offset(10)
		}
	}
	
	// MARK: - Public Methods
	
	func configure(with movie: Movie) {
		let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")
		loadImage(with: url)
		titleLabel.text = movie.originalTitle
	}
	
	func loadImage(with url: URL?) {
		showLoadingAnimation()
		imageView.kf.setImage(
			with: url,
			options: [
				.transition(.fade(0.25)),
				.scaleFactor(UIScreen.main.scale),
				.cacheOriginalImage]
		) { [weak self] result in
			switch result {
			case .success(_):
				self?.hideLoadingAnimation()
			case .failure(_):
				self?.hideLoadingAnimation()
			}
		}
	}
	
	func showLoadingAnimation() {
		imageView.showAnimatedSkeleton()
	}
	
	func hideLoadingAnimation() {
		imageView.hideSkeleton()
	}
}
