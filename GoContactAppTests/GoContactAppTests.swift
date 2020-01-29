//
//  GoContactAppTests.swift
//  GoContactAppTests
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import XCTest
@testable import GoContactApp

class GoContactAppTests: XCTestCase {

    var apiManager: APIManager?

    override func setUp() {
        apiManager = APIManager()
    }

    override func tearDown() {
        apiManager = nil
    }

    func testApiCall() {

        let requestURL = "contacts.json"

        let promise = expectation(description: "Status code: 200")

        apiManager?.requestData(url: requestURL, method: .get, parameters: nil, completion: { (result) in

                   DispatchQueue.main.async {

                       switch result {
                       case .success(let returnJson) :
                        promise.fulfill()

                       case .failure(let failure) :
                            XCTFail("Failure: \(failure)")
                       }
                   }
               })
        wait(for: [promise], timeout: 10)
    }


}
