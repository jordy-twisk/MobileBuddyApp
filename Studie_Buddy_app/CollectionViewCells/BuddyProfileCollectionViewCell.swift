//
//  BuddyProfileCollectionViewCell.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 29/04/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

class BuddyProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var StudyLabel: UILabel!
    @IBOutlet weak var LocationQLabel: UILabel!
    @IBOutlet weak var LocationALabel: UILabel!
    @IBOutlet weak var PreStudyQLabel: UILabel!
    @IBOutlet weak var PreStudyALabel: UILabel!
    @IBOutlet weak var BioQLabel: UILabel!
    @IBOutlet weak var BioALabel: UILabel!
    @IBOutlet weak var ReadMoreButton: UIButton!
    @IBOutlet weak var ViewWidthConstraint: NSLayoutConstraint!
    
//    @IBAction func ReadMoreButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let DetailBuddyPage = (storyboard.instantiateViewController(withIdentifier:
//                "DetailPageBuddyViewController") as? detailpagebuddyviewcontroller)!
//        BuddySwipeController.present(DetailBuddyPage, animated: true, completion: nil)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        ViewWidthConstraint.constant = screenWidth
        ViewWidthConstraint.isActive = true
        ReadMoreButton.tintColor = .InhollandPink
//        print("screen width is: ", screenWidth)
        self.contentView.isUserInteractionEnabled = false
        NameLabel.textAlignment = .center
        NameLabel.font = .boldSystemFont(ofSize: 20)
        StudyLabel.textAlignment = .center
        
        ProfileImageView.contentMode = .scaleAspectFill
        ProfileImageView.layer.cornerRadius = ProfileImageView.frame.size.width / 2
        ProfileImageView.clipsToBounds = true
        
        
        LocationQLabel.text = NSLocalizedString("location", comment: "")
        LocationQLabel.textColor = .InhollandPink
        LocationQLabel.font = .boldSystemFont(ofSize: 16)
        PreStudyQLabel.text = NSLocalizedString("prestudy", comment: "")
        PreStudyQLabel.textColor = .InhollandPink
        PreStudyQLabel.font = .boldSystemFont(ofSize: 16)
        BioQLabel.text = NSLocalizedString("bio", comment: "")
        BioQLabel.textColor = .InhollandPink
        BioQLabel.font = .boldSystemFont(ofSize: 16)
        ReadMoreButton.setTitle(NSLocalizedString("readmore", comment: ""), for: .normal)
        ProfileImageView.image = UIImage(named: "Profile")
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}


