//
//  InboxTableViewCell.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 13/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit



final class InboxTableViewCell: UITableViewCell{

    @IBOutlet weak var NewMessagesLabel: UILabel!
    @IBOutlet weak var InboxDateLabel: UILabel!
    @IBOutlet weak var InboxChatName: UILabel!
    @IBOutlet weak var InboxLatestChat: UILabel!
    @IBOutlet weak var InboxProfileImage: UIImageView!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    let bubblebackgroundview = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NewMessagesLabel.textColor = .lightGray
        InboxDateLabel.textColor = .lightGray
        InboxLatestChat.textColor = .lightGray
        InboxChatName.textColor = .black
        bubblebackgroundview.backgroundColor = .InhollandPink
        NewMessagesLabel.textColor = .black
        
        NewMessagesLabel.text = "10"
            
        addSubview(NewMessagesLabel)
        NewMessagesLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        NewMessagesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubblebackgroundview.layer.cornerRadius = 8
        addSubview(bubblebackgroundview)
        bubblebackgroundview.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            NewMessagesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            NewMessagesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            NewMessagesLabel.widthAnchor.constraint(equalToConstant: 20),
            NewMessagesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            bubblebackgroundview.topAnchor.constraint(equalTo: NewMessagesLabel.topAnchor, constant: 0),
            bubblebackgroundview.leadingAnchor.constraint(equalTo: NewMessagesLabel.leadingAnchor, constant: 0),
            bubblebackgroundview.bottomAnchor.constraint(equalTo: NewMessagesLabel.bottomAnchor, constant: 0),
            bubblebackgroundview.trailingAnchor.constraint(equalTo: NewMessagesLabel.trailingAnchor, constant:0)
        ]
        NSLayoutConstraint.activate(constraints)
 }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       // MessagePayloadLabel.text = nil
        
    }
}

