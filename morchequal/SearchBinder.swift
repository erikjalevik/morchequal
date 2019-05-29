//
//  SearchBinder.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

// MARK: Procotols

protocol SearchBinderProtocol {
    var tracks: [Track] { get }
    func searchForMorcheebaTracks(
        completionHandler: @escaping () -> Void
    )
}


// MARK: Implementation

// A binder is essentially a view model, but with a more appropriate name.
class SearchBinder: SearchBinderProtocol {
    var tracks: [Track] = []
    
    private let iTunesClient: ITunesClientProtocol

    init(client: ITunesClientProtocol = ITunesClient()) {
        self.iTunesClient = client
    }
    
    func searchForMorcheebaTracks(completionHandler: @escaping () -> Void) {
        let artist = "morcheeba"
        iTunesClient.searchForSongs(by: artist) { [weak self] maybeTracks in
            switch maybeTracks {
                case .success(let tracks):
                    self?.tracks = tracks
                    completionHandler()
                case .failure:
                    self?.tracks = []
                    completionHandler()
            }
        }
    }

}
