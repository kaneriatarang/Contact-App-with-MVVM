//
//  ContactDetailsViewModel.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 09/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import Foundation

class ContactDetailsViewModel {

    public enum homeError {
        case internetError(String)
        case serverMessage(String)
    }

    var contact: Contact?

    var didUpdate: ((ContactDetailsViewModel) -> Void)?

    public var isLoading : ((Bool)->Void)?

    public var onError : ((homeError)->Void)?

    let requestManager: RequestManager

    init(requestManager: RequestManager = RequestManager()) {
        self.requestManager = requestManager
    }

    public func requestData(requestUrl: String) {

        self.isLoading?(true)

        requestManager.getContactDetails(requestUrl: requestUrl) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.isLoading?(false)

            switch result {
            case .success(let contact) :

                strongSelf.contact = contact
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

    func favoriteChange(requestUrl: String) {

        guard let contactObj = contact else { return }
        contact?.favorite =  !contactObj.favorite

        self.isLoading?(true)

        requestManager.updateContact(isEdit: true, contact: contact!) { [weak self] result in

            guard let strongSelf = self else { return }
            strongSelf.isLoading?(false)

            switch result {
            case .success(let contact) :

                strongSelf.contact = contact
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

