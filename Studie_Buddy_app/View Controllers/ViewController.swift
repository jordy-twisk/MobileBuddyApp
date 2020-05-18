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
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        if isPressed == false {
            isPressed = true
            LoadingIndicator.isHidden = false
            LoadingIndicator.startAnimating()
            let username = UsernameTextbox.text
            let password = PasswordTextbox.text
            if username != "" && password != ""{
            ApiManager.LogUserIn(username: username!, password: password!).responseString { response in
                let AuthToken =  response.value
                self.LoadingIndicator.stopAnimating()
                self.LoadingIndicator.isHidden = true
                if AuthToken == nil || AuthToken == ""{
                    self.isPressed = false
                    print("wrong credentials")
                    let wronginput = UIAlertController(title: NSLocalizedString("tryagain", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

                    wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

                    self.present(wronginput, animated: true)
                }else {
                    KeychainWrapper.standard.set(username!, forKey: "StudentID")
                    KeychainWrapper.standard.set(AuthToken!, forKey: "AuthToken")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as UIViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                }
            }else{
                isPressed = false
            print("no credentials")
                self.LoadingIndicator.stopAnimating()
                self.LoadingIndicator.isHidden = true
                
                let wronginput = UIAlertController(title: NSLocalizedString("fill_in", comment: ""), message: NSLocalizedString("wrongInput", comment: ""), preferredStyle: .alert)

                wronginput.addAction(UIAlertAction(title: NSLocalizedString("tryagain", comment: ""), style: .default, handler: nil))

                present(wronginput, animated: true)
            }
            
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

