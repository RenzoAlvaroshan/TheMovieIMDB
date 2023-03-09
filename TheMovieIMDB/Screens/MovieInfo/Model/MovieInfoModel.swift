//
//  MovieInfoModel.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Foundation

// MARK: - YoutubeSearchResponse

struct YoutubeSearchResponse: Codable {
	let items: [VideoElement]
}

struct VideoElement: Codable {
	let id: IdVideoElement
}

struct IdVideoElement: Codable {
	let kind: String
	let videoId: String
}

// MARK: - UserReviewsResponse

struct UserReviewsResponse: Codable {
	let results: [UserReview]
}

struct UserReview: Codable {
	let author: String
	let content: String
}
