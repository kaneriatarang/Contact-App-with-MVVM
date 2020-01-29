//
//  EditContactViewModel.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 09/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import Foundation

class EditContactViewModel {

    public enum homeError {
        case internetError(String)
        case serverMessage(String)
    }

    var contact: Contact?

    var firstname: String?

    var lastname: String?

    var phoneNumber: String?

    var email: String?

    var isLoading : ((Bool)->Void)?

    var onError : ((homeError)->Void)?

    var didUpdate: ((EditContactViewModel) -> Void)?

    var navigateBack: (() -> ())?

    let requestManager: RequestManager

    init(requestManager: RequestManager = RequestManager()) {
        self.requestManager = requestManager
    }

    public func loadData(contact: Contact) {

        self.contact = contact

        self.firstname = contact.firstName
        self.lastname = contact.lastName
        self.phoneNumber = contact.phoneNumber
        self.email = contact.email
        self.didUpdate?(self)

    }

    func submitContact(isEdit: Bool = false) {

        let validData = [firstname, lastname, phoneNumber, email].filter {
            ($0?.count ?? 0) == 0
        }

        guard validData.count == 0 else {
            self.onError?(.serverMessage("Please Fill all the fields"))
            return
        }

        let updateContact: Contact?

        if isEdit {
            self.contact?.firstName = firstname ?? ""
            self.contact?.lastName = lastname ?? ""
            self.contact?.phoneNumber = phoneNumber
            self.contact?.email = email
            updateContact = self.contact
        } else {
            let newContact = Contact(id: 0, firstName: firstname ?? "", lastName: lastname ?? "", email: email, phoneNumber: phoneNumber, profilePic: nil, url: nil, createdAt: nil, updatedAt: nil, favorite: false)
            updateContact = newContact
        }

        self.isLoading?(true)

        requestManager.updateContact(isEdit: isEdit, contact: updateContact!) { [weak self] result in

            guard let strongSelf = self else { return }
            strongSelf.isLoading?(false)

            switch result {
            case .success :

                strongSelf.navigateBack?()

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

