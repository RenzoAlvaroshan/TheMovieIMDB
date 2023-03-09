//
//  MovieSectionController.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 08/03/23.
//

import IGListKit

final class MovieSectionController: ListSectionController {
	
	// MARK: - Properties
	
	private var movie: Movie?
	
	// MARK: - Initialization
	
	override init() {
		super.init()
		inset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
	}
	
	// MARK: - ListSectionController
	
	override func sizeForItem(at index: Int) -> CGSize {
		guard let context = collectionContext, let movie = movie else { return .zero }
		let width = context.containerSize.width - inset.left - inset.right
		let titleHeight = (movie.originalTitle ?? "").height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14, weight: .bold))
		return CGSize(width: width, height: titleHeight + 160)
	}
	
	override func cellForItem(at index: Int) -> UICollectionViewCell {
		guard let cell = collectionContext?.dequeueReusableCell(of: MovieGridCell.self, for: self, at: index) as? MovieGridCell, let movie = movie else {
			fatalError("Could not dequeue cell of correct type or movie is nil")
		}
		cell.configure(with: movie)
		return cell
	}
	
	override func didUpdate(to object: Any) {
		self.movie = object as? Movie
	}
}

private extension String {
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
		return ceil(boundingBox.height)
	}
}
