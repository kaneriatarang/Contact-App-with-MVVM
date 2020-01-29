//
//  ContactHomeViewModelTest.swift
//  GoContactAppTests
//
//  Created by Tarang Kaneriya on 10/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import XCTest
@testable import GoContactApp

class ContactHomeViewModelTest: XCTestCase {

    var requestManager: MockRequestManager?

    override func setUp() {
        requestManager = MockRequestManager()
    }

    override func tearDown() {
        requestManager = nil
    }

    func testNormalGetContact() {

        requestManager?.getContactResult = .success(payload: [Contact.with()])

        let viewModel = ContactHomeViewModel(requestManager: requestManager!)
        viewModel.requestData()

        XCTAssert(viewModel.contactList.count == 1)

    }

    func testEmptyGetContact() {

        requestManager?.getContactResult = .success(payload: [])

        let viewModel = ContactHomeViewModel(requestManager: requestManager!)
        viewModel.requestData()

        XCTAssert(viewModel.contactList.isEmpty)
    }

}
