//
//  ProfileViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 02/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit

var Studentprofile: Student?
var loggedin: Bool = true
class profileviewcontroller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var PreStudyTextbox: UITextField!
    @IBOutlet weak var CityTextbox: UITextField!
    @IBOutlet weak var StudyTextbox: UITextField!
    @IBOutlet weak var BioTextbox: UITextField!
    @IBOutlet weak var ProfileNameTextbox: UITextField!
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavigationBar.title = NSLocalizedString("profile", comment: "")
        //let InhollandPink = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        ProfileImageView.image = UIImage(named: "Profile")
        if loggedin == false{
            //ProfileImageView.image = UIImage(named: "Profile")
            ProfileNameTextbox.placeholder = NSLocalizedString("name", comment: "")
            BioTextbox.placeholder = NSLocalizedString("bio", comment: "")
            StudyTextbox.placeholder = NSLocalizedString("study", comment: "")
            CityTextbox.placeholder = NSLocalizedString("city", comment: "")
            PreStudyTextbox.placeholder = NSLocalizedString("prestudy", comment: "")
            RegisterButton.setTitle(NSLocalizedString("register", comment: ""), for: .normal)
        }else if loggedin == true{
            Makeprofilecall()
        }
        
        RegisterButton.backgroundColor = .InhollandPink
        RegisterButton.tintColor = UIColor.white
            
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        
 }
    
    
    func Makeprofilecall(){
        ApiManager.getProfile(studentID: 123456).responseData(completionHandler: { [weak self] (response) in
        let jsonData = response.data!
        let decoder = JSONDecoder()
        Studentprofile = try? decoder.decode(Student.self, from: jsonData)
        self!.ProfileNameTextbox.placeholder = Studentprofile?.firstname
        self!.BioTextbox.placeholder = Studentprofile?.description
        self!.StudyTextbox.placeholder = Studentprofile?.study
        self!.CityTextbox.placeholder = Studentprofile?.degree
        self!.PreStudyTextbox.placeholder = Studentprofile?.interests
        self!.RegisterButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        })
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        if self.ProfileNameTextbox.text != ""{
            Studentprofile?.firstname = ProfileNameTextbox.text!
            
            ProfileNameTextbox.text = ""
            
        }
        if self.BioTextbox.text != ""{
            Studentprofile?.description = BioTextbox.text!
            BioTextbox.text = ""
            
            
        }
        if self.StudyTextbox.text != ""{
            Studentprofile?.study = StudyTextbox.text!
            StudyTextbox.text = ""
                    }
        if self.CityTextbox.text != ""{
            Studentprofile?.degree = CityTextbox.text!
            CityTextbox.text = ""
            
        }
        if self.PreStudyTextbox.text != ""{
            Studentprofile?.interests = PreStudyTextbox.text!
            PreStudyTextbox.text = ""
            
        }
        ProfileNameTextbox.placeholder = Studentprofile?.firstname
        BioTextbox.placeholder = Studentprofile?.description
        StudyTextbox.placeholder = Studentprofile?.study
        CityTextbox.placeholder = Studentprofile?.degree
        PreStudyTextbox.placeholder = Studentprofile?.interests
        
        ApiManager.updateProfile(student: Studentprofile!).responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            print(Studentprofile?.firstname, Studentprofile?.description, Studentprofile?.degree, Studentprofile?.interests)
                print(jsonData)
        })
        
        //Makeprofilecall()
    
    }
    
    
    @IBAction func OpenCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                 let imagepicker = UIImagePickerController()
                 imagepicker.delegate = self
                 imagepicker.sourceType = UIImagePickerController.SourceType.camera
                 imagepicker.allowsEditing = false
                 self.present(imagepicker, animated: true, completion: nil)
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            ProfileImageView.contentMode = .scaleToFill
            ProfileImageView.image = pickedimage
        }
        picker.dismiss(animated: true, completion: nil)
    }

}
