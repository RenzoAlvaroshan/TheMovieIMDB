//
//  MovieAPI.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import Moya

struct Constants {
	static let API_KEY = "82d755c4d1db25ea38bc0943dea7764c"
	static let baseURL = "https://api.themoviedb.org"
	static let YoutubeAPI_KEY = "AIzaSyAFvJplcxXoaAQ1aLIMmRJKaTI37RzSy20"
	static let YoutubeBaseURL = "https://youtube.googleapis.com"
}

enum MovieAPI {
	case discoverMovies(page: Int)
	case searchMovie(query: String)
	case getMovieReviews(movieId: Int)
}

extension MovieAPI: TargetType {
	
	var baseURL: URL {
		switch self {
		case .discoverMovies:
			return URL(string: Constants.baseURL)!
		case .searchMovie:
			return URL(string: Constants.YoutubeBaseURL)!
		case .getMovieReviews:
			return URL(string: Constants.baseURL)!
		}
	}
	
	var path: String {
		switch self {
		case .discoverMovies:
			return "/3/discover/movie"
		case .searchMovie:
			return "/youtube/v3/search"
		case .getMovieReviews(let movieId):
			return "/3/movie/\(movieId)/reviews"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .discoverMovies:
			return .get
		case .searchMovie:
			return .get
		case .getMovieReviews:
			return .get
		}
	}
	
	var task: Moya.Task {
		switch self {
		case .discoverMovies(let page):
			let parameters: [String: Any] = [
				"api_key": Constants.API_KEY,
				"language": "en-US",
				"sort_by": "popularity.desc",
				"include_adult": "false",
				"include_video": "false",
				"page": "\(page)"
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
			
		case .searchMovie(query: let query):
			guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
					return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
				}
			let parameters: [String: Any] = [
				"q": "\(query)",
				"key": Constants.YoutubeAPI_KEY,
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
			
		case .getMovieReviews(_):
			let parameters: [String: Any] = [
				"api_key": Constants.API_KEY,
				"language": "en-US"
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		nil
	}
}
