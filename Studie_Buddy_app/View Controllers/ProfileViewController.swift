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
import SwiftKeychainWrapper
import CoreData

var Studentprofile: Student?
var profileOfStudent: [StudentProfile]?
var loggedin: Bool = true
var BioPlaceholder: String = ""
class profileviewcontroller: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate {
    
    var activeField: UITextField?
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var PreStudyTextbox: UITextField!
    @IBOutlet weak var CityTextbox: UITextField!
    @IBOutlet weak var StudyTextbox: UITextField!
    @IBOutlet weak var BioTextBox: UITextView!
    @IBOutlet weak var ProfileNameTextbox: UITextField!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ChoosePictureButton: UIButton!
    @IBOutlet weak var UpdateIndicator: UIActivityIndicatorView!
    
   
    @IBOutlet weak var BioProfileLabel: UILabel!
    @IBOutlet weak var InterestsProfileLabel: UILabel!
    @IBOutlet weak var StudyyearProfileLabel: UILabel!
    @IBOutlet weak var StudyLabelProfile: UILabel!
    @IBOutlet weak var NameProfileLabel: UILabel!
    @IBOutlet weak var IconBioProfileImage: UIImageView!
    @IBOutlet weak var IconStudyProfileImage: UIImageView!
    
    @IBOutlet weak var IconInterestsProfileImage: UIImageView!
    @IBOutlet weak var IconStudyyearProfileImage: UIImageView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistenceContainer.viewContext
    
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
    
    @IBAction func EditingchangedInterests(_ sender: UITextField) {
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
    
    /* core data fetch data */
    
    func fetchStudentProfile(){
        
        let studentid = KeychainWrapper.standard.string(forKey: "AuthID")
        if studentid != ""{
            do {
                
                let filter = NSPredicate(format: "studentid CONTAINS '581433'")
                let request = StudentProfile.fetchRequest() as NSFetchRequest<StudentProfile>
                request.predicate = filter

                profileOfStudent = try context.fetch(StudentProfile.fetchRequest())
                if profileOfStudent?.isEmpty == false {
                    self.ProfileNameTextbox.placeholder =  profileOfStudent![0].firstname
                    self.BioTextBox.text =  profileOfStudent![0].bio
                    self.BioTextBox.textColor = .lightGray
                    self.StudyTextbox.placeholder =  profileOfStudent![0].study
                    self.CityTextbox.placeholder =  profileOfStudent![0].studyyear
                    self.PreStudyTextbox.placeholder =  profileOfStudent![0].interests
                    if (profileOfStudent![0].photo?.isEmpty == false) {
                        let ImageUrl = URL(string:  profileOfStudent![0].photo!)
                        self.ProfileImageView.kf.setImage(with: ImageUrl)
                    }
                }
                else{
                    let savePerson = StudentProfile(context: self.context)
                    
                    savePerson.studentid = Int64(studentid!)!
                    savePerson.firstname = "Name"
                    savePerson.bio = "Bio"
                    savePerson.study = "Study"
                    savePerson.studyyear = "Studyyear"
                    savePerson.interests = "Interests"
                    
                    do{
                        try context.save()
                    }catch{
                        //catch error to let user know of error
                    }
                    fetchStudentProfile()
                }
                
            }catch{
            
            }
            
        }
            
        
        
       
    }
 
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UpdateIndicator.isHidden = true
        UpdateIndicator.startAnimating()
        NavigationBar.title = NSLocalizedString("profile", comment: "")
        ChoosePictureButton.setTitle(NSLocalizedString("ChoosePic", comment: ""), for: .normal)
        ChoosePictureButton.tintColor = .InhollandPink
        //let InhollandPink = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        ProfileImageView.image = UIImage(named: "Profile")
            //ProfileImageView.image = UIImage(named: "Profile")
        ProfileImageView.contentMode = .scaleAspectFill
        ProfileImageView.layer.cornerRadius = ProfileImageView.frame.size.width / 2
        ProfileImageView.clipsToBounds = true
        StudyLabelProfile.text = NSLocalizedString("study", comment: "")
        StudyLabelProfile.textColor = .InhollandPink
        StudyLabelProfile.font = .boldSystemFont(ofSize: 16)
        
        NameProfileLabel.text = NSLocalizedString("name", comment: "")
        NameProfileLabel.textColor = .InhollandPink
        NameProfileLabel.font = .boldSystemFont(ofSize: 16)
        
        StudyyearProfileLabel.text = NSLocalizedString("StudyYear", comment: "")
        StudyyearProfileLabel.textColor = .InhollandPink
        StudyyearProfileLabel.font = .boldSystemFont(ofSize: 16)

        InterestsProfileLabel.text = NSLocalizedString("Interests", comment: "")
        InterestsProfileLabel.textColor = .InhollandPink
        InterestsProfileLabel.font = .boldSystemFont(ofSize: 16)
        
        BioProfileLabel.text = NSLocalizedString("bio", comment: "")
        BioProfileLabel.textColor = .InhollandPink
        BioProfileLabel.font = .boldSystemFont(ofSize: 16)
        
        IconStudyProfileImage.image = UIImage(systemName: "books.vertical")
        IconStudyProfileImage.tintColor = .InhollandPink
        
        IconStudyyearProfileImage.image = UIImage(systemName: "calendar")
        IconStudyyearProfileImage.tintColor = .InhollandPink
        
        IconInterestsProfileImage.image = UIImage(systemName: "exclamationmark.bubble.fill")
        IconInterestsProfileImage.tintColor = .InhollandPink
        
        
        IconBioProfileImage.image = UIImage(systemName: "person.crop.square.fill.and.at.rectangle")
        IconBioProfileImage.tintColor = .InhollandPink
        
        
        //Makeprofilecall()
        fetchStudentProfile()
        NavigationBar.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Logout", comment: ""), style: .plain, target: self, action: #selector(LogUserOut))
        NavigationBar.leftBarButtonItem = nil
        
        
       // let viewtap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileviewcontroller.dismissing))
       // view.addGestureRecognizer(viewtap)
        
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
    
    @objc func LogUserOut(){
        print(UserDefaults.standard.dictionaryRepresentation().keys)
        UserDefaults.standard.set(0, forKey: "MessageAmount")
        UserDefaults.standard.set(0, forKey: "NumberOfTutoranten")
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        NewNotificationsMessages = []
        KeychainWrapper.standard.set("", forKey: "StudentID")
        KeychainWrapper.standard.set("", forKey: "AuthToken")
        KeychainWrapper.standard.set("", forKey: "Password")
        KeychainWrapper.standard.set("", forKey: "CoachID")
        KeychainWrapper.standard.set("", forKey: "Name")
        KeychainWrapper.standard.set("", forKey: "Bio")
        KeychainWrapper.standard.set("", forKey: "Study")
        KeychainWrapper.standard.set("", forKey: "Degree")
        KeychainWrapper.standard.set("", forKey: "Interests")
        KeychainWrapper.standard.set("", forKey: "Photo")
        newMessages = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginPageViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if BioTextBox.textColor == UIColor.lightGray {
            BioTextBox.text = nil
            BioTextBox.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if BioTextBox.text.isEmpty {
            BioTextBox.text = BioPlaceholder
            BioTextBox.textColor = UIColor.lightGray
        }
    }
    
    func Makeprofilecall(){
        //let studentID = Int(KeychainWrapper.standard.string(forKey: "StudentID")!)
        //print(studentID)
        //self.UpdateIndicator.isHidden = true
        /*-----------------------API CALL--------------------------
        ApiManager.getProfile(studentID: studentID!).responseData(completionHandler: { [weak self] (response) in
            self!.UpdateIndicator.isHidden = false
            let jsonData = response.data!
            let decoder = JSONDecoder()
            Studentprofile = try? decoder.decode(Student.self, from: jsonData)
            self!.ProfileNameTextbox.placeholder = Studentprofile?.firstname
            BioPlaceholder = Studentprofile!.description
            self!.BioTextBox.text = Studentprofile?.description
            self!.BioTextBox.textColor = .lightGray
            self!.StudyTextbox.placeholder = Studentprofile?.study
            self!.CityTextbox.placeholder = Studentprofile?.degree
            self!.PreStudyTextbox.placeholder = Studentprofile?.interests
            let ImageUrl = URL(string: Studentprofile!.photo)
            self!.ProfileImageView.kf.setImage(with: ImageUrl)
            self!.UpdateIndicator.isHidden = true

        })
 
        */
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        
        
        //-----------------API NOT WORKING: --------------
        do{
            let filter = NSPredicate(format: "studentid CONTAINS '581433'")
            let request = StudentProfile.fetchRequest() as NSFetchRequest<StudentProfile>
            request.predicate = filter

            profileOfStudent = try context.fetch(StudentProfile.fetchRequest())
            
        }catch{
            
        }
       
        
        
        var name = profileOfStudent![0].firstname
        var bio = profileOfStudent![0].bio
        var study = profileOfStudent![0].study
        var studyyear = profileOfStudent![0].studyyear
        var interests = profileOfStudent![0].interests
        
        
        if (ProfileNameTextbox.text!.isEmpty == false || BioTextBox.text!.isEmpty == false || StudyTextbox.text!.isEmpty == false || CityTextbox.text!.isEmpty == false || PreStudyTextbox.text!.isEmpty == false) {
            
       
            
        if self.ProfileNameTextbox.text != ""{
            
            //Studentprofile?.firstname = ProfileNameTextbox.text!
            name = ProfileNameTextbox.text!
            ProfileNameTextbox.text = ""
            
        }
        if self.BioTextBox.text != ""{
            
            //Studentprofile?.description = BioTextBox.text!
            bio = BioTextBox.text!
            BioTextBox.text = ""
            
            
        }
        if self.StudyTextbox.text != ""{
            
            //Studentprofile?.study = StudyTextbox.text!
            study = StudyTextbox.text!
            StudyTextbox.text = ""
                    }
        if self.CityTextbox.text != ""{
            
            //Studentprofile?.degree = CityTextbox.text!
            studyyear = CityTextbox.text!
            CityTextbox.text = ""
            
        }
        if self.PreStudyTextbox.text != ""{
            
            //Studentprofile?.interests = PreStudyTextbox.text!
            interests = PreStudyTextbox.text!
            PreStudyTextbox.text = ""
            
        }
        /*
        ProfileNameTextbox.placeholder = Studentprofile?.firstname
        BioTextbox.placeholder = Studentprofile?.description
        StudyTextbox.placeholder = Studentprofile?.study
        CityTextbox.placeholder = Studentprofile?.degree
        PreStudyTextbox.placeholder = Studentprofile?.interests
 */
        //-----------------API CALL NOT WORKING-------
            //KeychainWrapper.standard.set(name, forKey: "Name")
            //KeychainWrapper.standard.set(bio, forKey: "Bio")
            //KeychainWrapper.standard.set(study, forKey: "Study")
            //KeychainWrapper.standard.set(studyyear, forKey: "Degree")
            //KeychainWrapper.standard.set(interests, forKey: "Interests")
            
            
            let savePerson = profileOfStudent![0]
            
            savePerson.firstname = name
            savePerson.bio = bio
            savePerson.study = study
            savePerson.studyyear = studyyear
            savePerson.interests = interests
            
            do{
                try context.save()
                fetchStudentProfile()
            }catch{
                //catch error to let user know of error
            }
            
            //Makeprofilecall()
        
        //-----------------API CALL WORKING------------
            /*
        ApiManager.updateProfile(student: Studentprofile!).responseData(completionHandler: { [weak self] (response) in
            self!.UpdateIndicator.isHidden = false
            self!.RegisterButton.backgroundColor = .gray
           // let jsonData = response.data!
            self!.Makeprofilecall()
        })
        */
        
        }
    }

}

