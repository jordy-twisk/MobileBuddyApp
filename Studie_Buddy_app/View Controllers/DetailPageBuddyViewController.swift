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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
