//
//  ContactTest.swift
//  GoContactAppTests
//
//  Created by Tarang Kaneriya on 09/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import XCTest
@testable import GoContactApp

class ContactTest: XCTestCase {

    var jsonData: Data?

    override func setUp() {

        let testJSON : [String: Any] = [
            "id": 1010,
            "first_name": "Tarang",
            "last_name": "Kaneriya",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "http://gojek-contacts-app.herokuapp.com/contacts/1010.json"
        ]

        do {
            jsonData = try JSONSerialization.data(withJSONObject: testJSON, options: JSONSerialization.WritingOptions()) as Data
        } catch _ {
            print ("JSON Failure")
        }

    }

    override func tearDown() {
        jsonData = nil
    }

    func testContactObjectParsing() {
        XCTAssertNotNil(Contact.init(data: jsonData!))
    }
}


extension Contact {
    static func with(id: Int = 10,
                     firstname: String = "Tarang",
                     lastname: String = "Swift",
                     email: String = "abc@gmail.com",
                     phonenumber: String = "0501234567",
                     profilePic: String = "/images/missing.png",
                     url: String = "http://gojek-contacts-app.herokuapp.com/contacts/10.json",
                     createdAt: String = "2020-01-07T04:13:51.278Z",
                     updatedAt: String = "2020-01-07T04:13:51.278Z",
                     favorite: Bool = false ) -> Contact
    {
        return Contact(id: id, firstName: firstname, lastName: lastname, email: email, phoneNumber: phonenumber, profilePic: profilePic, url: url, createdAt: createdAt, updatedAt: updatedAt, favorite: favorite)
    }
}
