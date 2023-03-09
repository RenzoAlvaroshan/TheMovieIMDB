//
//  MovieGridCell.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 08/03/23.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieGridCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	static let reuseIdentifier = "MovieGridCell"

	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		label.numberOfLines = 2
		return label
	}()

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(imageView.snp.leading).offset(10)
			make.bottom.equalTo(imageView.snp.bottom).inset(10)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration

	func configure(with movie: Movie) {
		let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")
		imageView.kf.setImage(
			with: url,
			options: [
				.transition(.fade(0.25)),
				.scaleFactor(UIScreen.main.scale),
				.cacheOriginalImage]
		)
		titleLabel.text = movie.originalTitle
	}
}
