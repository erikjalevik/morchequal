//
//  ITunesClientTests.swift
//  morchequalTests
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import XCTest
@testable import morchequal

class ITunesClientTests: XCTestCase {
    var iTunesClient: ITunesClient?
    var mockFetcher: MockFetcher?

    class MockFetcher: FetcherProtocol {
        func get(
            url: URL,
            completionHandler: @escaping FetchCompletionHandler
        ) {
            let badJson = "Not JSON".data(using: .utf8)!
            completionHandler(.success(badJson))
        }
    }
    
    override func setUp() {
        let fetcher = MockFetcher()
        iTunesClient = ITunesClient(fetcher: fetcher)
        mockFetcher = fetcher
    }

    func testHandlingOfBadJson() {
        let expectation = XCTestExpectation()

        iTunesClient?.searchForSongs(by: "dummy") { list in
            if case .success = list {
                XCTFail("Expected .failure when fetcher returned bad JSON")
            } else {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // TODO: In production code, we'd have some more tests here.
}
