//
//  EditContactViewController.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField! {
        didSet {
            firstnameTextField.delegate = self
            firstnameTextField.addTarget(self, action: #selector(firstnameTextFieldDidChange), for: .editingChanged)
        }
    }

    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDidChange), for: .editingChanged)
        }
    }

    @IBOutlet weak var phoneNumberTextField: UITextField! {
        didSet {
            phoneNumberTextField.delegate = self
            phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
        }
    }

    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        }
    }

    var editContactViewModel = EditContactViewModel()

    var selectedContact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()

        if let contact = selectedContact {
            editContactViewModel.loadData(contact: contact)
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
    
    }


    @objc func firstnameTextFieldDidChange(textField: UITextField){
        editContactViewModel.firstname = textField.text ?? ""
    }

    @objc func lastNameTextFieldDidChange(textField: UITextField){
        editContactViewModel.lastname = textField.text ?? ""
    }

    @objc func phoneNumberTextFieldDidChange(textField: UITextField){
        editContactViewModel.phoneNumber = textField.text ?? ""
    }

    @objc func emailTextFieldDidChange(textField: UITextField){
        editContactViewModel.email = textField.text ?? ""
    }

    // MARK: - Bindings

    private func setupBindings() {

        // Binding loading to ViewContoller
        editContactViewModel.isLoading = { [weak self] (isLoading) in
            guard let strongSelf = self else { return }
            isLoading ? strongSelf.startAnimating() : strongSelf.stopAnimating()
        }


        // Observing errors to show
        editContactViewModel.onError = { (error) in
            switch error {
            case .internetError(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .error)
            case .serverMessage(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .warning)
            }
        }

        editContactViewModel.didUpdate = { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModelDidUpdate()
        }

        editContactViewModel.navigateBack = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }

    }

    private func viewModelDidUpdate() {

        guard let contactObj = editContactViewModel.contact else { return }

        firstnameTextField.text = contactObj.firstName
        lastNameTextField.text = contactObj.lastName
        phoneNumberTextField.text = contactObj.phoneNumber
        emailTextField.text = contactObj.email

    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        editContactViewModel.submitContact(isEdit: selectedContact != nil)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        editContactViewModel.navigateBack?()
    }
}


extension EditContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
