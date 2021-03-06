//
//  DetailPageBuddyViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 11/05/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import SAConfettiView

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
    @IBOutlet weak var BioALabel: UITextView!
    //@IBOutlet weak var BioALabel: UILabel!
    @IBOutlet weak var ChooseBuddyButton: UIButton!
    
    
    var name: String = ""
    var photo: String = ""
    var bio: String = ""
    var degree: String = ""
    var study: String = ""
    var studyyear: String = ""
    var interests: String = ""
    var coachID: Int = 0
    var ShowBackButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ShowBackButton == false{
            navigationController?.isNavigationBarHidden = true
            ChooseBuddyButton.isHidden = true
        }
        
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
        let ImageUrl = URL(string: photo)
        ProfileImageView.kf.setImage(with: ImageUrl)
        NameLabel.text = name
        StudyALabel.text = study
        StudyyearALabel.text = studyyear
        PrestudyALabel.text = degree
        InterestALabel.text = interests
        BioALabel.text = bio
        BioALabel.isEditable = false
        BioALabel.isSelectable = false
        
        
        ChooseBuddyButton.addTarget(self, action: #selector(ChooseThisbuddyCall), for: .touchUpInside)
    }
    
    @objc func ChooseThisbuddyCall(){
        ApiManager.chooseBuddy(coachID: coachID).responseData(completionHandler: { [weak self] (response) in
        //let jsonData = response.data!
            
            //print("response http status code: ",response.response?.statusCode)
            if response.response?.statusCode == 201{
                KeychainWrapper.standard.set(self!.coachID, forKey: "CoachID")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let HomePage = (storyboard.instantiateViewController(withIdentifier:"homeviewcontroller") as? homeviewcontroller)!
//                self!.navigationController?.pushViewController(HomePage, animated: true)
                let confettiView = SAConfettiView(frame: self!.view.bounds)
                confettiView.type = .Confetti
                confettiView.colors = [UIColor.InhollandPink, UIColor.purple, UIColor.red]
                confettiView.intensity = 1
                self!.view.addSubview(confettiView)
                confettiView.startConfetti()
                let alert = UIAlertController(title: NSLocalizedString("NewCoachTitle", comment: ""), message: NSLocalizedString("NewCoachMSG", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "") , style: .default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
                confettiView.stopConfetti()
                self!.tabBarController?.selectedIndex = 0
                }))
                self!.present(alert, animated: true, completion: nil)
        }
       // let decoder = JSONDecoder()
        //let tutorants = try? decoder.decode([Tutorants].self, from: jsonData)
        })
        
        
        
    }
    
}
