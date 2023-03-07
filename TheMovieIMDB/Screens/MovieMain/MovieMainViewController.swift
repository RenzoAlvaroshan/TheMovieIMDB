//
//  MovieMainViewController.swift
//  TheMovieIMDB
//
//  Created by Renzo Alvaroshan on 07/03/23.
//

import UIKit
import IGListKit

final class MovieMainViewController: UIViewController {
	
	// MARK: - Properties
	
	private let viewModel: MovieMainViewModel
	
	// MARK: - Initialization
	
	init(viewModel: MovieMainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	// MARK: - Selectors
	
	// MARK: - Helpers
	
	
}
