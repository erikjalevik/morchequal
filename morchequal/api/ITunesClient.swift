//
//  ITunesClient.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import Foundation


// MARK: Constants

let hostname = "https://itunes.apple.com/"


// MARK: Implementation

class ITunesClient {
    private let fetcher: FetcherProtocol

    init(fetcher: FetcherProtocol = Fetcher()) {
        self.fetcher = fetcher
    }
    
    func searchForSongs(
        by artist: String,
        completionHandler: @escaping (Result<SongList, Error>) -> Void
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

        fetcher.get(url: url) { (data: Result<Data, Error>) in
            let dict = data.flatMap(parseJson)
            switch dict {
                case .success(let dict):
                    let songs = SongList(from: dict)
                    completionHandler(.success(songs))
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
            }
        }
    }
}
