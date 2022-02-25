//
//  MoviesCleanAppEndToEndTests.swift
//  MoviesCleanAppEndToEndTests
//
//  Created by Luiz Hammerli on 24/02/22.
//

import XCTest
import Infra
import Data

final class MoviesCleanAppEndToEndTests: XCTestCase {
    func test_endToEndTestServerGetFeedResult_matchesFixedTestAccountData() {
        let httpClient = URLSessionHttpGetClient(urlSession: URLSession(configuration: .ephemeral))
        let strURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=da3239f04025a1e8fa95d19e374e8a24"
        let url = URL(string: strURL)!
        let remoteFeedLoader = RemoteMovieLoader(url: url, httpClient: httpClient)
        
        let exp = expectation(description: "Waiting for request")
        remoteFeedLoader.load { result in
            switch result {
            case .success(let movies):
                XCTAssertFalse(movies.isEmpty)
            case .failure(let error):
                XCTFail("Expected success with movies result, got \(error) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
}
