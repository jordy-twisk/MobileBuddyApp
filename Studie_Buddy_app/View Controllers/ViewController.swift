//
//  ViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 12/11/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    
    @IBOutlet weak var NavigationBAr: UINavigationItem!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var UsernameTextbox: UITextField!
    @IBOutlet weak var PasswordTextbox: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //HeaderImage.image = UIImage(named: "header")
        
        LoginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        RegisterButton.setTitle(NSLocalizedString("registerhere", comment: ""), for: .normal)


        UsernameTextbox.placeholder = NSLocalizedString("username", comment: "")
        PasswordTextbox.placeholder = NSLocalizedString("password", comment: "")
        PasswordTextbox.isSecureTextEntry = true
        
        
        NavigationBAr.title = NSLocalizedString("login", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.title = NSLocalizedString("login", comment: "")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }


}

