//
//  ProfileViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 02/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

var Studentprofile: Student?
var loggedin: Bool = true
class profileviewcontroller: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    var activeField: UITextField?
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var PreStudyTextbox: UITextField!
    @IBOutlet weak var CityTextbox: UITextField!
    @IBOutlet weak var StudyTextbox: UITextField!
    @IBOutlet weak var BioTextbox: UITextField!
    @IBOutlet weak var ProfileNameTextbox: UITextField!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ChoosePictureButton: UIButton!
    @IBOutlet weak var UpdateIndicator: UIActivityIndicatorView!
    
    @IBAction func TakePicture(_ sender: Any) {
        
       /* if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        */
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
 
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            ProfileImageView.contentMode = .scaleToFill
            ProfileImageView.image = pickedimage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EditingchangedName(_ sender: UITextField) {
        setSaveButtonPink()
    }
    
    @IBAction func EditingchangedDegree(_ sender: UITextField) {
        setSaveButtonPink()
    }
    
    @IBAction func EditingchangedInterest(_ sender: UITextField) {
        setSaveButtonPink()
    }
    
    @IBAction func EditingchangedStudy(_ sender: UITextField) {
        setSaveButtonPink()
    }
    
    @IBAction func EditingchangedBio(_ sender: UITextField) {
        setSaveButtonPink()
    }
    
    func setSaveButtonPink(){
        RegisterButton.backgroundColor = .InhollandPink
    }
    
    
    
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UpdateIndicator.isHidden = true
        UpdateIndicator.startAnimating()
        NavigationBar.title = NSLocalizedString("profile", comment: "")
        ChoosePictureButton.setTitle(NSLocalizedString("ChoosePic", comment: ""), for: .normal)
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
        
        let viewtap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileviewcontroller.dismissing))
        view.addGestureRecognizer(viewtap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil )
        
        RegisterButton.backgroundColor = .gray
        RegisterButton.tintColor = UIColor.white
        RegisterButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
            
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        
 }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil )
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil )
    }
    
    @objc func keyboardWillChange(notification: Notification){
        
        ScrollView.isScrollEnabled = true
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        
        ScrollView.contentInset = contentInsets
        ScrollView.scrollIndicatorInsets = contentInsets
        /*
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardFrame.height
        if let activeField = self.activeField {
            if (aRect.contains(activeField.frame.origin)){
                ScrollView.scrollRectToVisible(activeField, animated: true)
            }
            
        }
        */
        let sizeToButton = view.frame.maxY - RegisterButton.frame.height
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            let heightToMove = keyboardFrame.height - ((navigationController?.navigationBar.frame.height)! + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height)!)
            view.frame.origin.y = -heightToMove - sizeToButton
        }else {
            view.frame.origin.y = (navigationController?.navigationBar.frame.height)! + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height)!
            ScrollView.isScrollEnabled = false
        }
        
    }
    
    func textfieldDidBeginEditing(_ textfield: UITextField){
        activeField = textfield
        
    }
    
    func textfieldDidEndEditing(){
        activeField = nil
    }
    
    @objc func dismissing(){
        self.view.endEditing(true)
    }
    
    func Makeprofilecall(){
        ApiManager.getProfile(studentID: 123456).responseData(completionHandler: { [weak self] (response) in
            self!.UpdateIndicator.isHidden = false
        let jsonData = response.data!
        let decoder = JSONDecoder()
        Studentprofile = try? decoder.decode(Student.self, from: jsonData)
            print(Studentprofile!.firstname,Studentprofile!.surname, Studentprofile!.degree, Studentprofile!.description, Studentprofile!.interests, Studentprofile!.phonenumber, Studentprofile!.photo, Studentprofile!.study, Studentprofile!.studyyear, Studentprofile!.studentid)
        self!.ProfileNameTextbox.placeholder = Studentprofile?.firstname
        self!.BioTextbox.placeholder = Studentprofile?.description
        self!.StudyTextbox.placeholder = Studentprofile?.study
        self!.CityTextbox.placeholder = Studentprofile?.degree
        self!.PreStudyTextbox.placeholder = Studentprofile?.interests
        let ImageUrl = URL(string: Studentprofile!.photo)
        self!.ProfileImageView.kf.setImage(with: ImageUrl)
            self!.UpdateIndicator.isHidden = true
        
        })
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        if (ProfileNameTextbox.text!.isEmpty == false || BioTextbox.text!.isEmpty == false || StudyTextbox.text!.isEmpty == false || CityTextbox.text!.isEmpty == false || PreStudyTextbox.text!.isEmpty == false) {
            
       
            
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
        /*
        ProfileNameTextbox.placeholder = Studentprofile?.firstname
        BioTextbox.placeholder = Studentprofile?.description
        StudyTextbox.placeholder = Studentprofile?.study
        CityTextbox.placeholder = Studentprofile?.degree
        PreStudyTextbox.placeholder = Studentprofile?.interests
 */
        
        ApiManager.updateProfile(student: Studentprofile!).responseData(completionHandler: { [weak self] (response) in
            self!.UpdateIndicator.isHidden = false
            self!.RegisterButton.backgroundColor = .gray
           // let jsonData = response.data!
            self!.Makeprofilecall()
        })
        
        
        }
    }

}
