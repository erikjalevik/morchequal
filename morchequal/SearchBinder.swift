//
//  SearchBinder.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import UIKit


// MARK: Procotols

protocol SearchBinderProtocol {
    var tracks: [Track] { get }
    func searchForTracks(
        by artist: String,
        completionHandler: @escaping () -> Void
    )
    func getFormattedReleaseDate(for track: Track) -> String
    func getArtwork(
        for track: Track,
        completionHandler: @escaping (UIImage) -> Void
    ) -> UIImage
}


// MARK: Implementation

// A binder is essentially a view model, but with a more appropriate name.
class SearchBinder: SearchBinderProtocol {
    var tracks: [Track] = []
    
    private let iTunesClient: ITunesClientProtocol
    private let artworkCache: NSCache<NSString, UIImage>
    
    private let dateFormatter = DateFormatter()

    init(
        client: ITunesClientProtocol,
        artworkCache: NSCache<NSString, UIImage>
    ) {
        self.iTunesClient = client
        self.artworkCache = artworkCache
    }
    
    func searchForTracks(
        by artist: String,
        completionHandler: @escaping () -> Void
    ) {
        iTunesClient.searchForTracks(by: artist) { [weak self] maybeTracks in
            switch maybeTracks {
                case .success(let tracks):
                    self?.tracks = tracks.sorted {
                        $0.releaseDate < $1.releaseDate
                    }
                    completionHandler()
                case .failure:
                    self?.tracks = []
                    completionHandler()
            }
        }
    }
    
    func getFormattedReleaseDate(for track: Track) -> String {
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: track.releaseDate)
    }
    
    // This function has a somewhat quirky API, due to the requirement of using
    // Apple-only APIs.
    //
    // If called for the first time for a track, it immediately returns a
    // placeholder image, and then delivers the real artwork once downloaded
    // using the completionHandler. It also sticks the downloaded image into
    // its artwork cache.
    //
    // If called again for the same track, it immediately returns the cached
    // image and the completionHandler is never called.
    //
    // This is the kind of use case where RX Observables would really shine
    // as we could just return a stream of values via one asynchronous
    // mechanism instead of having this two-fold approach.
    func getArtwork(
        for track: Track,
        completionHandler: @escaping (UIImage) -> Void
    ) -> UIImage {
        let cacheKey = track.artworkUrl as NSString
        if let cachedImage = artworkCache.object(forKey: cacheKey) {
            return cachedImage
        } else {
            let placeholder = UIImage(named: "AlbumPlaceholder")!

            // Download image from URL on a background thread
            DispatchQueue.global(qos: .background).async {
                guard
                    let url = URL(string: track.artworkUrl),
                    let data = try? Data(contentsOf: url), // causes HTTP fetch
                    let image = UIImage(data: data)
                else {
                    completionHandler(placeholder)
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.artworkCache.setObject(image, forKey: cacheKey)
                    completionHandler(image)
                }
            }
            return placeholder
        }
    }

}
