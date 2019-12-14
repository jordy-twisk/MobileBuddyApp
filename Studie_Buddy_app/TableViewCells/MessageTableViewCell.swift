//
//  MessageTableViewCell.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

final class MessageTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MessagePayloadLabel: UILabel!
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    
    var incomming: Bool!{
        didSet{
            bubblebackgroundview.backgroundColor = incomming ? UIColor(white: 0.9, alpha: 1) : UIColor(white: 0.5, alpha: 1)
            MessagePayloadLabel.textColor = incomming ? .black : .white
            
            if incomming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else
            {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
        let bubblebackgroundview = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MessagePayloadLabel.numberOfLines = 0
        
        
        bubblebackgroundview.layer.cornerRadius = 20
        addSubview(bubblebackgroundview)
        bubblebackgroundview.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(MessagePayloadLabel)
        MessagePayloadLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        MessagePayloadLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let constraints = [
            MessagePayloadLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            MessagePayloadLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            MessagePayloadLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubblebackgroundview.topAnchor.constraint(equalTo: MessagePayloadLabel.topAnchor, constant: -16),
            bubblebackgroundview.leadingAnchor.constraint(equalTo: MessagePayloadLabel.leadingAnchor, constant: -16),
            bubblebackgroundview.bottomAnchor.constraint(equalTo: MessagePayloadLabel.bottomAnchor, constant: 16),
            bubblebackgroundview.trailingAnchor.constraint(equalTo: MessagePayloadLabel.trailingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = MessagePayloadLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = true
        
        trailingConstraint = MessagePayloadLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        MessagePayloadLabel.text = nil
        
    }
}
