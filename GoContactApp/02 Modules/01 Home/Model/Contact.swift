//
//  Contact.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import Foundation
import SwiftyJSON

//final class Contact: JsonDecodable {
//
//    typealias JsonObjectType = Contact
//
//    private (set) var id: Int = 0
//    private (set) var firstName: String = ""
//    private (set) var lastName: String = ""
//    private (set) var email: String = ""
//    private (set) var phoneNumber: String = ""
//    private (set) var profilePic: String = ""
//    private (set) var url: String = ""
//    private (set) var createdAt: String = ""
//    private (set) var updatedAt: String = ""
//
//    private (set) var favorite: Bool = false
//
//    required init(json: JSON) {
//
//        id = json ["id"].intValue
//        firstName = json ["first_name"].stringValue
//        lastName = json ["last_name"].stringValue
//        email = json ["email"].stringValue
//        phoneNumber = json ["phone_number"].stringValue
//        profilePic = json ["profile_pic"].stringValue
//        url = json ["url"].stringValue
//        createdAt = json ["created_at"].stringValue
//        updatedAt = json ["updated_at"].stringValue
//        favorite = json ["favorite"].boolValue
//
//    }
//}
//

struct Contact: Codable {

    var id :Int
    var firstName, lastName : String
    var email, phoneNumber, profilePic, url, createdAt, updatedAt : String?
    var favorite: Bool

    var name: String { firstName + " " + lastName }

    enum CodingKeys: String, CodingKey {
        case id, email, url, favorite
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}


// MARK: Convenience initializers

extension Contact {

    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Contact.self, from: data)
            self = me
        }
        catch {
            print(error)
            return nil
        }
    }

    func encode() -> Data {

        let jsonData = try! JSONEncoder().encode(self)
        return jsonData
    }
}
