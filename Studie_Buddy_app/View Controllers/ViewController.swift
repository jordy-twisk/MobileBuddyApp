//
//  ViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 12/11/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ViewController: UIViewController {

   
    
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
        
        // Do any additional setup after loading the view.
        //HeaderImage.image = UIImage(named: "header")
        
        LoginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        //RegisterButton.setTitle(NSLocalizedString("registerhere", comment: ""), for: .normal)


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

         let calender = Calendar.current
        guard let lastRefreshDate = UserDefaults.standard.object(forKey: "LastLogin") as? Date else {
                return true
            }

            if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 24 {
                return true
            } else {
                return false
            }
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

