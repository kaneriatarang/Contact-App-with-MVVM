//
//  ContactDetailsViewController.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 09/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    @IBOutlet weak var isFavoriteButton: UIButton!
    @IBOutlet weak var nametLabel: UILabel!
    @IBOutlet weak var phoneNumbertTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    var contactDetailsViewModel = ContactDetailsViewModel()
    var contactUrl: String = ""

    private let editContactSegue = "editContactSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()

    }

    override func viewWillAppear(_ animated: Bool) {
        contactDetailsViewModel.requestData(requestUrl: contactUrl)

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

    @IBAction func favoriteTapped(_ sender: UIButton) {
        contactDetailsViewModel.favoriteChange(requestUrl: contactUrl)
    }

    // MARK: - Bindings

    private func setupBindings() {

        // Binding loading to Viewcontroller
        contactDetailsViewModel.isLoading = { [weak self] (isLoading) in
            guard let strongSelf = self else { return }
            isLoading ? strongSelf.startAnimating() : strongSelf.stopAnimating()
        }

        // Observing errors to show
        contactDetailsViewModel.onError = { (error) in
            switch error {
            case .internetError(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .error)
            case .serverMessage(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .warning)
            }
        }

        // Observing Updates from ViewModel
        contactDetailsViewModel.didUpdate = { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModelDidUpdate()
        }

    }

    private func viewModelDidUpdate() {

        guard let contactObj = contactDetailsViewModel.contact else { return }
        
        nametLabel.text = contactObj.name
        phoneNumbertTextField.text = contactObj.phoneNumber
        emailTextField.text = contactObj.email

        isFavoriteButton.setImage(contactObj.favorite ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button"), for: .normal)
    }


    @IBAction func editTapped(_ sender: UIButton) {
        performSegue(withIdentifier: editContactSegue, sender: contactDetailsViewModel.contact)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       if let identifier = segue.identifier {
           switch identifier {
           case editContactSegue :
            if let viewController = (segue.destination as? UINavigationController)?.viewControllers.first as? EditContactViewController {
                viewController.selectedContact = sender as? Contact
               }
           default:
               break
           }
       }
       super.prepare(for: segue, sender: sender)
    }
}
