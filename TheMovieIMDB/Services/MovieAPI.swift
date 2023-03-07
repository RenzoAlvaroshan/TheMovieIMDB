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
	static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum MovieAPI {
	case discoverMovies(page: Int)
}

extension MovieAPI: TargetType {
	
	var baseURL: URL {
		return URL(string: Constants.baseURL)!
	}
	
	var path: String {
		switch self {
		case .discoverMovies:
			return "/3/discover/movies"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var task: Moya.Task {
		switch self {
		case .discoverMovies(let page):
			let parameters: [String: Any] = [
				"api_key": Constants.API_KEY,
				"language": "en-US",
				"sort_by": "popularity.desc",
				"include_video": "false",
				"page": "\(page)"
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		nil
	}
}

