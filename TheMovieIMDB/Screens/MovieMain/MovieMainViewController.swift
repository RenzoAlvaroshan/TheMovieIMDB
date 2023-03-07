//
//  MovieMainViewController.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import UIKit

final class MovieMainViewController: UIViewController {
	
	// MARK: - Properties
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
	
	// MARK: - Selectors
	
	// MARK: - Helpers
	
	private func configureUI() {
		view.backgroundColor = .systemRed
	}
}
