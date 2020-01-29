//
//  RequestManager.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 10/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import Foundation

class RequestManager {

// MARK: - Get Contacts

    typealias GetContactResult = Result<[Contact], RequestError>
    typealias GetContactCompletion = (_ result: GetContactResult) -> Void

    func getContact(completion: @escaping GetContactCompletion) {

        let apiManager = APIManager()

        let requestURL = "contacts.json"

        apiManager.requestData(url: requestURL, method: .get, parameters: nil, completion: { (result) in

            DispatchQueue.main.async {

                switch result {
                case .success(let returnJson) :

                    let contactList = returnJson.arrayValue.compactMap {return Contact(data: try! $0.rawData())}
                    completion(.success(payload: contactList))

                case .failure(let failure) :

                    completion(.failure(failure))

                }
            }
        })
    }

    // MARK: - Get Contact Details

    typealias UpdateContactResult = Result<Contact, RequestError>
    typealias UpdateContactCompletion = (_ result: UpdateContactResult) -> Void

    func getContactDetails(requestUrl: String, completion: @escaping UpdateContactCompletion) {

        let apiManager = APIManager()

        apiManager.requestData(isWithBaseUrl: false, url: requestUrl, method: .get, parameters: nil, completion: { (result) in

            DispatchQueue.main.async {

                switch result {
                case .success(let returnJson) :

                    if let contact = Contact.init(data: try! returnJson.rawData()) {
                        completion(.success(payload: contact))
                    } else {
                        completion(.failure(RequestError.unknownError))
                    }

                case .failure(let failure) :

                    completion(.failure(failure))

                }
            }

        })

    }

// MARK: - Update Contact

    func updateContact(isEdit: Bool, contact: Contact, completion: @escaping UpdateContactCompletion) {

        let apiManager = APIManager()

        let requestUrl = isEdit ? "contacts/" + String(contact.id) + ".json" :  "contacts.json"
        let method = isEdit ? HTTPMethod.put : HTTPMethod.post
        let parameter = contact.encode()

        apiManager.requestData(url: requestUrl, method: method, parameters: parameter, completion: { (result) in

            DispatchQueue.main.async {

                switch result {
                case .success(let returnJson) :

                    if let contact = Contact.init(data: try! returnJson.rawData()) {
                        completion(.success(payload: contact))
                    } else {
                        completion(.failure(RequestError.unknownError))
                    }

                case .failure(let failure) :

                    completion(.failure(failure))

                }
            }

        })

    }
}


enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}

final class MockRequestManager: RequestManager {
    
    var getContactResult: RequestManager.GetContactResult?

     override func getContact(completion: @escaping RequestManager.GetContactCompletion) {
        completion(getContactResult!)
    }

}
