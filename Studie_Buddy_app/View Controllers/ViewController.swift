//
//  ViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 12/11/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class User: Equatable, Hashable{
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username && lhs.password == rhs.password && lhs.isCoach == rhs.isCoach && lhs.name == rhs.name && lhs.bio == rhs.bio && lhs.study == rhs.study && lhs.degree == rhs.degree && lhs.interests == rhs.interests && lhs.photo == rhs.photo
    }
    
    var username: String
    var password: String
    var isCoach: Bool = false
    var name: String
    var bio: String
    var study: String
    var degree: String
    var interests: String
    var photo: String
    
    init(username: String, password: String, isCoach: Bool, name: String, bio: String, study: String, degree: String, interests: String, photo: String) {
            self.username = username
            self.password = password
            self.isCoach = false
            self.name = name
            self.bio = bio
            self.study = study
            self.degree = degree
            self.interests = interests
            self.photo = photo
        }

    var hashValue: Int {
            get {
                return username.hashValue + password.hashValue + isCoach.hashValue + name.hashValue + bio.hashValue + study.hashValue + degree.hashValue + degree.hashValue + interests.hashValue + photo.hashValue
            }
        }
}

var Users: [User] = []

class ViewController: UIViewController {
    
    
    var UserToLogin: User = User(username: "", password: "", isCoach: false, name: "", bio: "", study: "", degree: "", interests: "", photo: "")
    
    @IBOutlet weak var NavigationBAr: UINavigationItem!
    //@IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var UsernameTextbox: UITextField!
    @IBOutlet weak var PasswordTextbox: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    
    
    
    var isPressed: Bool = false
    override func viewDidLoad() {
        LoadingIndicator.isHidden = true
        LoadingIndicator.color = .white
        
        super.viewDidLoad()
        CheckIfUserIsLoggedIn()
        
        
        //----------------LOCAL WITHOUT API ADD USERS ---------------------
        Users.insert(User(username: "581433", password: "test", isCoach: true, name: "Mark", bio: "Student", study: "Wetenschap", degree: "HBO", interests: "Voetbal", photo: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Johnny_Depp-2757_%28cropped%29.jpg/440px-Johnny_Depp-2757_%28cropped%29.jpg"), at: 0)
        // Do any additional setup after loading the view.
        //HeaderImage.image = UIImage(named: "header")
        
        LoginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        //RegisterButton.setTitle(NSLocalizedString("registerhere", comment: ""), for: .normal)
        UsernameTextbox.backgroundColor = .white
        PasswordTextbox.backgroundColor = .white
            
        LoginButton.backgroundColor = .white
        UsernameTextbox.placeholder = NSLocalizedString("username", comment: "")
        PasswordTextbox.placeholder = NSLocalizedString("password", comment: "")
        PasswordTextbox.isSecureTextEntry = true
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        
        //NavigationBAr.title = NSLocalizedString("login", comment: "")
        //self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        //self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        //self.navigationController?.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func CheckIfUserIsLoggedIn(){
        let userIsLoggedIn =  UserDefaults.standard.bool(forKey: "LoggedIn")
        if userIsLoggedIn == true {
            if isRefreshRequired() {
                let username = KeychainWrapper.standard.string(forKey: "StudentID")
                let password = KeychainWrapper.standard.string(forKey: "Password")
                LoginUser(username: username!, password: password!)
                UserDefaults.standard.set(Date(), forKey: "LastLogin")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
           
        
    }

    func isRefreshRequired() -> Bool {
        /* ---------------------- UNCOMMENT FOR WORKING WITH API ------------------------------
         let calender = Calendar.current
        guard let lastRefreshDate = UserDefaults.standard.object(forKey: "LastLogin") as? Date else {
                return true
            }

            if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 24 {
                return true
            } else {
                return false
            }
 */
        return false
        }
        
    
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        if isPressed == false {
            isPressed = true
            let username = UsernameTextbox.text!
            let password = PasswordTextbox.text!
            LoginUser(username: username, password: password)
        }
    }
    
    func LoginUser(username: String, password: String){
        LoadingIndicator.isHidden = false
        LoadingIndicator.startAnimating()
        if username != "" && password != ""{
            
            
            UserToLogin.username = username
            UserToLogin.password = password
        /*----------------------- WHEN API NOT WORKING-----------------------*/
            if Users.contains(where: { $0.username == UserToLogin.username }){         //User is known
                let indexOfUser = Users.firstIndex(where: { $0.username == UserToLogin.username })
                if Users[indexOfUser!].password == password{
                    UserDefaults.standard.set(Users[indexOfUser!].isCoach , forKey: "UserIsCoach")
                    self.LoadingIndicator.stopAnimating()
                    self.LoadingIndicator.isHidden = true
                    let iscoach = UserDefaults.standard.bool(forKey: "UserIsCoach")
                    print("user is coach?: ",iscoach)
                    KeychainWrapper.standard.set(username, forKey: "StudentID")
                    KeychainWrapper.standard.set(password, forKey: "Password")
                    KeychainWrapper.standard.set(Users[indexOfUser!].name, forKey: "Name")
                    KeychainWrapper.standard.set(Users[indexOfUser!].bio, forKey: "Bio")
                    KeychainWrapper.standard.set(Users[indexOfUser!].study, forKey: "Study")
                    KeychainWrapper.standard.set(Users[indexOfUser!].degree, forKey: "Degree")
                    KeychainWrapper.standard.set(Users[indexOfUser!].interests , forKey: "Interests")
                    KeychainWrapper.standard.set(Users[indexOfUser!].photo, forKey: "Photo")
                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as UIViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    self.LoadingIndicator.stopAnimating()
                    self.LoadingIndicator.isHidden = true
                    self.isPressed = false
                    print("wrong credentials")
                    let wronginput = UIAlertController(title: NSLocalizedString("tryagain", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

                    wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

                    self.present(wronginput, animated: true)
                }
            }
            else{
                self.LoadingIndicator.stopAnimating()
                self.LoadingIndicator.isHidden = true
                self.isPressed = false
                print("wrong credentials")
                let wronginput = UIAlertController(title: NSLocalizedString("tryagain", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

                wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

                self.present(wronginput, animated: true)
            }
        }
        else{
            self.LoadingIndicator.stopAnimating()
            self.LoadingIndicator.isHidden = true
            isPressed = false
            print("no credentials")
            self.LoadingIndicator.stopAnimating()
            self.LoadingIndicator.isHidden = true
            
            let wronginput = UIAlertController(title: NSLocalizedString("fill_in", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

            wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

            present(wronginput, animated: true)
            
        }
            
            
            
            
        /* ---------------------- UNCOMMENT FOR WORKING WITH API ------------------------------
        ApiManager.LogUserIn(username: username, password: password).responseString { response in
            let AuthToken =  response.value
            self.LoadingIndicator.stopAnimating()
            self.LoadingIndicator.isHidden = true
            if AuthToken == nil || AuthToken == ""{
                self.LoadingIndicator.stopAnimating()
                self.LoadingIndicator.isHidden = true
                self.isPressed = false
                print("wrong credentials")
                let wronginput = UIAlertController(title: NSLocalizedString("tryagain", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

                wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

                self.present(wronginput, animated: true)
            }else {
                
                ApiManager.CheckIfUserIsCoach().responseData(completionHandler: { [weak self] (responsecoach) in
                    
                if responsecoach.response?.statusCode == 200{
                    UserDefaults.standard.set(true, forKey: "UserIsCoach")
                } else
                {
                    //print(response.response?.statusCode)
                    ApiManager.CheckIfUserIsTutorant().responseData(completionHandler: { [weak self] (responsetutorant) in
                    if responsetutorant.response?.statusCode == 200{
                        UserDefaults.standard.set(false, forKey: "UserIsCoach")
                    }
                    self!.LoadingIndicator.stopAnimating()
                    self!.LoadingIndicator.isHidden = true
                    })
                }
                self!.LoadingIndicator.stopAnimating()
                self!.LoadingIndicator.isHidden = true
                let iscoach = UserDefaults.standard.bool(forKey: "UserIsCoach")
                print("user is coach?: ",iscoach)
                KeychainWrapper.standard.set(username, forKey: "StudentID")
                KeychainWrapper.standard.set(AuthToken!, forKey: "AuthToken")
                KeychainWrapper.standard.set(password, forKey: "Password")
                UserDefaults.standard.set(true, forKey: "LoggedIn")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as UIViewController
                self!.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
            
        }else{
            self.LoadingIndicator.stopAnimating()
            self.LoadingIndicator.isHidden = true
            isPressed = false
            print("no credentials")
            self.LoadingIndicator.stopAnimating()
            self.LoadingIndicator.isHidden = true
            
            let wronginput = UIAlertController(title: NSLocalizedString("fill_in", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

            wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

            present(wronginput, animated: true)
            
        }
 
    */
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
/*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
*/
}

