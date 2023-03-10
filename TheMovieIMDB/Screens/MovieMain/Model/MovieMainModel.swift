//
//  MovieMainModel.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Foundation

struct MovieResponse: Codable {
	let results: [Movie]
}

struct Movie: Codable, Equatable {
	let id: Int
	let mediaType: String?
	let originalName: String?
	let originalTitle: String?
	let posterPath: String?
	let overview: String?
	let releaseDate: String?

	enum CodingKeys: String, CodingKey {
		case id
		case mediaType = "media_type"
		case originalName = "original_name"
		case originalTitle = "original_title"
		case posterPath = "poster_path"
		case overview
		case releaseDate = "release_date"
	}
}
