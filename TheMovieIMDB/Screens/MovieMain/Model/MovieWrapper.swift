//
//  MovieWrapper.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 08/03/23.
//

import Foundation
import IGListKit

class MovieWrapper: NSObject, Codable, ListDiffable {
	let movie: Movie
	
	init(movie: Movie) {
		self.movie = movie
	}
	
	func diffIdentifier() -> NSObjectProtocol {
		return movie.id as NSObjectProtocol
	}
	
	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object as? MovieWrapper else {
			return false
		}
		return movie.id == object.movie.id
	}
}
