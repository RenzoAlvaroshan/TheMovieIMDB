//
//  UserReviewCell.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 09/03/23.
//

import UIKit

final class UserReviewCell: UITableViewCell {
	
	// MARK: - Properties
	
	static let reuseIdentifier: String = "UserReviewCell"
	
	private let authorLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.textColor = UIColor.label
		label.numberOfLines = 1
		label.setContentCompressionResistancePriority(.required, for: .horizontal)
		return label
	}()
	
	private let contentLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.textColor = UIColor.label
		label.numberOfLines = 0
		return label
	}()
	
	private let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.systemGray6
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		return view
	}()
	
	private let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.systemGray3
		return view
	}()
	
	// MARK: - Initialization
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		configureView()
		configureConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	
	private func configureView() {
		selectionStyle = .none
		contentView.addSubview(containerView)
		containerView.addSubview(authorLabel)
		containerView.addSubview(contentLabel)
		containerView.addSubview(separatorView)
	}
	
	private func configureConstraints() {
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(8)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		authorLabel.snp.makeConstraints { make in
			make.top.leading.equalToSuperview().inset(8)
			make.trailing.lessThanOrEqualToSuperview().inset(8)
		}
		
		contentLabel.snp.makeConstraints { make in
			make.top.equalTo(authorLabel.snp.bottom).offset(8)
			make.leading.trailing.equalToSuperview().inset(8)
			make.bottom.equalTo(separatorView.snp.top).offset(-8)
		}
		
		separatorView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalTo(1)
		}
	}
	
	// MARK: - Configuration
	
	func configure(with userReview: UserReview) {
		authorLabel.text = userReview.author
		contentLabel.text = userReview.content
	}
}
