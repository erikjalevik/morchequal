//
//  ITunesClient.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import Foundation


// MARK: Constants

fileprivate let hostname = "https://itunes.apple.com/"


// MARK: Protocols

protocol ITunesClientProtocol {
    func searchForSongs(
        by artist: String,
        completionHandler: @escaping (Result<[Track], Error>) -> Void
    )
}


// MARK: Implementation

class ITunesClient: ITunesClientProtocol {
    private let fetcher: FetcherProtocol

    init(fetcher: FetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func searchForSongs(
        by artist: String,
        completionHandler: @escaping (Result<[Track], Error>) -> Void
    ) {
        let endpoint = "search";

        guard var comp = URLComponents(string: "\(hostname)\(endpoint)") else {
            // Using assert here and below since these operations should really
            // never fail in production, they indicate programmer error.
            let msg = "URLComponents creation failed";
            assertionFailure(msg)
            completionHandler(.failure(GenericError.runtimeError(msg)))
            return
        }

        let params: [String: Any] = [
            "term": artist,
        ]
        comp.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
     
        guard let url = comp.url else {
            let msg = "URL creation from components failed";
            assertionFailure(msg)
            completionHandler(.failure(GenericError.runtimeError(msg)))
            return
        }

        fetcher.get(url: url) { (maybeData: Result<Data, Error>) in
            let maybeList = maybeData
                .flatMap { data -> Result<TrackList, Error> in
                    let decoder = JSONDecoder()
                    return Result {
                        try decoder.decode(TrackList.self, from: data)
                    }
                }
            
            switch maybeList {
                case .success(let list):
                    let tracks = list.results.filter { t in t.kind == "song" }
                    completionHandler(.success(tracks))
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
            }
        }
    }
}
