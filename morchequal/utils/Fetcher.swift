//
//  Fetcher.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import Foundation


// MARK: Protocols

// We need to manually create these protocols and extensions in order to
// be able to unit test our fetcher with a mock URLSession.

protocol URLSessionProtocol {
    func dataTask(
        with: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return dataTask(
            with: request,
            completionHandler: completionHandler
        ) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

typealias FetchCompletionHandler = (Result<Data, Error>) -> Void

protocol FetcherProtocol {
    func get(url: URL, completionHandler: @escaping FetchCompletionHandler)
}


// MARK: Implementation

class Fetcher: FetcherProtocol {
    private let session: URLSessionProtocol
    private var dataTask: URLSessionDataTaskProtocol?

    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(url: URL, completionHandler: @escaping FetchCompletionHandler) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        perform(request: request, completionHandler: completionHandler)
    }
    
    // TODO: In a full-scale app, this would probably need methods for the other
    // HTTP verbs too, like POST, PUT, DELETE etc.

    private func perform(
        request: URLRequest,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        dataTask?.cancel()

        dataTask = session.dataTask(with: request) { [weak self] (
            data: Data?,
            response: URLResponse?,
            error: Error?
        ) in
            defer {
                self?.dataTask = nil
            }
    
            func complete(_ result: Result<Data, Error>) {
                DispatchQueue.main.async { completionHandler(result) }
            }

            guard error == nil else {
                // Could also have used an if let here to avoid having to
                // force-unwrap error twice below, but I prefer the semantics
                // of always using guard to indicate early out.
                print("Fetcher.get failed with error: " +
                    "\(error!.localizedDescription)")
                complete(.failure(error!))
                return
            }

            guard
                let data = data,
                let response = response,
                let httpResponse = response as? HTTPURLResponse
            else {
                let msg = "Fetcher.get failed due to bad response"
                print(msg)
                complete(.failure(GenericError.runtimeError(msg)))
                return
            }
    
            guard
                httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299
            else {
                let msg = "Fetcher.get failed with status code: " +
                    "\(httpResponse.statusCode)"
                print(msg)
                complete(.failure(GenericError.runtimeError(msg)))
                return
            }
    
            complete(.success(data))
        }
    
        dataTask?.resume()
    }
}
