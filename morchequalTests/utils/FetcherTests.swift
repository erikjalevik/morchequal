//
//  FetcherTests.swift
//  morchequalTests
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import XCTest
@testable import morchequal

class FetcherTests: XCTestCase {
    var fetcher: Fetcher?
    var mockSession: MockURLSession?

    class MockURLSession: URLSessionProtocol {
        var url: URL?
        var method: String?

        func dataTask(
            with request: URLRequest,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTaskProtocol {
            url = request.url
            method = request.httpMethod
            return MockURLSessionDataTask()
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTaskProtocol {
        func resume() {}
        func cancel() {}
    }

    override func setUp() {
        let session = MockURLSession()
        fetcher = Fetcher(session: session)
        mockSession = session
    }

    func testGet() {
        let testUrl = URL(string: "https://www.example.com/path?param=1")!
        
        fetcher?.get(url: testUrl) {_ in }
        
        XCTAssertEqual(mockSession?.url, testUrl, "Wrong URL passed to URLSession")
        XCTAssertEqual(mockSession?.method, "GET", "Wrong HTTP method passed to URLSession")
    }
    
    // TODO: In production code, we'd have some more tests here. Particularly
    // important would be testing the task cancellation and error handling.
}
