//
//  DetailPageBuddyViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 11/05/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

class detailpagebuddyviewcontroller: UIViewController{
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var StudyQLabel: UILabel!
    @IBOutlet weak var StudyALabel: UILabel!
    @IBOutlet weak var StudyyearQLabel: UILabel!
    @IBOutlet weak var StudyyearALabel: UILabel!
    @IBOutlet weak var PrestudyQLabel: UILabel!
    @IBOutlet weak var PrestudyALabel: UILabel!
    
    @IBOutlet weak var InterestQLabel: UILabel!
    @IBOutlet weak var InterestALabel: UILabel!
    @IBOutlet weak var BioQLabel: UILabel!
    @IBOutlet weak var BioALabel: UILabel!
    @IBOutlet weak var ChooseBuddyButton: UIButton!
    
    var name: String = ""
    var photo: String = ""
    var bio: String = ""
    var degree: String = ""
    var study: String = ""
    var studyyear: String = ""
    var interests: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseBuddyButton.tintColor = .InhollandPink
        //        print("screen width is: ", screenWidth)
                
        NameLabel.textAlignment = .center
        NameLabel.font = .boldSystemFont(ofSize: 22)
                
        StudyQLabel.text = NSLocalizedString("study", comment: "")
        StudyQLabel.textColor = .InhollandPink
        StudyQLabel.font = .boldSystemFont(ofSize: 16)
        StudyyearQLabel.text = NSLocalizedString("StudyYear", comment: "")
        StudyyearQLabel.textColor = .InhollandPink
        StudyyearQLabel.font = .boldSystemFont(ofSize: 16)
        PrestudyQLabel.text = NSLocalizedString("prestudy", comment: "")
        PrestudyQLabel.textColor = .InhollandPink
        PrestudyQLabel.font = .boldSystemFont(ofSize: 16)
        InterestQLabel.text = NSLocalizedString("Interests", comment: "")
        InterestQLabel.textColor = .InhollandPink
        InterestQLabel.font = .boldSystemFont(ofSize: 16)
        BioQLabel.text = NSLocalizedString("bio", comment: "")
        BioQLabel.textColor = .InhollandPink
        BioQLabel.font = .boldSystemFont(ofSize: 16)
        ChooseBuddyButton.setTitle(NSLocalizedString("ChooseThisBuddy", comment: ""), for: .normal)
        //ProfileImageView.image = UIImage(named: "Profile")
        
        
        
        

        NameLabel.text = name
        StudyALabel.text = study
        StudyyearALabel.text = studyyear
        PrestudyALabel.text = degree
        InterestALabel.text = interests
        BioALabel.text = bio
        
    }
    
}
