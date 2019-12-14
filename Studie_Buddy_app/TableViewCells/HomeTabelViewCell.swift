//
//  HomeTabelViewCell.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

final class HomeTableViewCell: UITableViewCell{
    
    @IBOutlet weak var ResponseButton: UIButton!
    @IBOutlet weak var NotificationDate: UILabel!
    @IBOutlet weak var Notification: UILabel!
    @IBOutlet weak var HeaderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        HeaderImage.image = UIImage(named: "header_notification")
        NotificationDate.text = "11/12/19"
        Notification.text = "Je hebt een nieuw bericht!"
        ResponseButton.setTitle("Reageer", for: .normal)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
