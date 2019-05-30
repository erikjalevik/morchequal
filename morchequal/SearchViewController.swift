//
//  SearchViewController.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import UIKit


// MARK: Constants

fileprivate let hardcodedArtist = "morcheeba"


// MARK: Implementation

class SearchViewController: UIViewController {

    private let binder: SearchBinderProtocol

    private let tableView = UITableView(frame: .zero)
    private let spinner = UIActivityIndicatorView()

    init(binder: SearchBinderProtocol) {
        self.binder = binder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        tableView.rowHeight = TrackCell.height
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.id)
        tableView.tableFooterView = UIView() // hide empty cell borders
        tableView.dataSource = self
        view.addSubview(tableView)

        spinner.style = UIActivityIndicatorView.Style.gray
        view.addSubview(spinner)

        constrain()
        bind()
    }
    
    private func constrain() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor),
            tableView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor),
            tableView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            spinner.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func bind() {
        // This isn't really binding anything right now, it just imperatively
        // kicks off the network request. In a production app, I would use
        // something like RxSwift here to make the values in the binder
        // into observables, which could then be subscribed to (or bound)
        // here in the view controller.
        spinner.startAnimating()
        self.binder.searchForTracks(by: hardcodedArtist) { [weak self] in
            self?.tableView.reloadData()
            self?.spinner.stopAnimating()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.binder.tracks.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackCell.id, for: indexPath
        ) as! TrackCell
        
        let track = self.binder.tracks[indexPath.row]
        cell.setInfo(from: track)

        let formatted = self.binder.getFormattedReleaseDate(for: track)
        cell.setReleaseDate(formatted: formatted)

        // We need to load the artwork asynchronously to keep the table view
        // scrolling smoothly.
        let initialArtwork = self.binder.getArtwork(for: track) { artwork in
            if let stillVisible = tableView.cellForRow(at: indexPath) {
                (stillVisible as! TrackCell).setArtwork(image: artwork)
            }
        }
        cell.setArtwork(image: initialArtwork)
        
        return cell
    }
}
