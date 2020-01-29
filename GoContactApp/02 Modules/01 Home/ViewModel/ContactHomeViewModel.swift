//
//  ContactHomeViewModel.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import Foundation

class ContactHomeViewModel {

    public enum homeError {
        case internetError(String)
        case serverMessage(String)
    }

    public var isLoading : ((Bool)->Void)?

    var contactList = [Contact]()

    var didUpdate: ((ContactHomeViewModel) -> Void)?

    public var onError : ((homeError)->Void)?

    let requestManager: RequestManager

    init(requestManager: RequestManager = RequestManager()) {
        self.requestManager = requestManager
    }

    public func requestData() {

        self.isLoading?(true)

        requestManager.getContact { [weak self] result in
            
            guard let strongSelf = self else { return }
            strongSelf.isLoading?(false)

            switch result {
            case .success(let contactList) :

                strongSelf.contactList = contactList
                strongSelf.didUpdate?(strongSelf)

            case .failure(let failure) :

                switch failure {

                case .connectionError:
                    strongSelf.onError?(.internetError("Check your Internet connection."))

                case .authorizationError(let errorJson):

                    strongSelf.onError?(.serverMessage(errorJson["message"].stringValue))

                default:

                    strongSelf.onError?(.serverMessage("Unknown Error"))
                }
            }
        }
    }
}

