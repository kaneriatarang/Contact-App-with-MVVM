//
//  ContactCell.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2

    }

    var contactData: Contact? {
        didSet {
            if let contact = contactData {
                nameLabel.text = contact.name
                favouriteImage.isHidden = !contact.favorite
            }
        }

    }

    static var defaultIdentifier: String { return "ContactCell" }
}
