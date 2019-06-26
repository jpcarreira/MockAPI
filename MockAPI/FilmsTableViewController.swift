//
//  FilmsTableViewController.swift
//  MockAPI
//
//  Created by João Carreira on 25/06/2019.
//  Copyright © 2019 João Carreira. All rights reserved.
//

import UIKit


class FilmsTableViewController: UITableViewController {
    
    private var filmsData: FilmsData? {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    private let api: Api = {
        if CommandLine.arguments.contains("-mockApi") {
            return MockApiClient()
        } else {
            return ApiClient()
        }
    }()
    
    private var activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.backgroundColor = .gray
        activityIndicatorView.center = tableView.center
        view.addSubview(activityIndicatorView)
        
        tableView.allowsSelection = false

        activityIndicatorView.startAnimating()
        api.fetchMovies { (success, filmsData) in
            self.filmsData = filmsData
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsData?.results.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmTableViewCell
        
        guard let film = filmsData?.results[indexPath.row] else {
            fatalError("Can't display film information")
        }
        
        cell.titleLabel.text = film.title
        cell.directorLabel.text = film.director
        cell.releaseDateLabel.text = film.releaseDate
        cell.backgroundColor = indexPath.row % 2 == 0 ? .clear : .lightGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
