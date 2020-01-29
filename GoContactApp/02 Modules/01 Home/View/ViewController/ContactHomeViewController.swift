//
//  ContactHomeViewController.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import UIKit
import Foundation

class ContactHomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var contactHomeViewModel = ContactHomeViewModel()

    private let showContactSegue = "showContactSegue"
    private let addContactSegue = "addContactSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contact"
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        contactHomeViewModel.requestData()
    }

    // MARK: - Bindings

    private func setupBindings() {

        // Binding loading to Viewcontroller
        contactHomeViewModel.isLoading = { [weak self] (isLoading) in
            guard let strongSelf = self else { return }
            isLoading ? strongSelf.startAnimating() : strongSelf.stopAnimating()
        }

        // Observing errors to show
        contactHomeViewModel.onError = { (error) in
            switch error {
            case .internetError(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .error)
            case .serverMessage(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .warning)
            }
        }

        // Observing Updates from ViewModel
        contactHomeViewModel.didUpdate = { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }

    }

    @IBAction func addTapped(_ sender: UIButton) {
        performSegue(withIdentifier: addContactSegue, sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let identifier = segue.identifier {
            switch identifier {
            case showContactSegue :
                if let viewController = segue.destination as? ContactDetailsViewController {
                    if let selectedContact = sender as? Contact {
                        viewController.contactUrl = selectedContact.url ?? ""
                    }
                }
            default:
                break
            }
        }
        super.prepare(for: segue, sender: sender)
    }
}

extension ContactHomeViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contactHomeViewModel.contactList[indexPath.row]
        self.performSegue(withIdentifier: showContactSegue, sender: selectedContact)
    }
}

extension ContactHomeViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactHomeViewModel.contactList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.defaultIdentifier, for: indexPath) as! ContactCell

        cell.contactData = contactHomeViewModel.contactList[indexPath.row]

        return cell

    }

}

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        let color2 = UIColor.init(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 0.28)
        gradientLayer.colors = [UIColor.white.cgColor, color2.cgColor]
    }
}
