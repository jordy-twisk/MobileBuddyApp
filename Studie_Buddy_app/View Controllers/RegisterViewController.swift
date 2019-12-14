//
//  RegisterViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 02/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import UIKit

class registerviewcontroller: UIViewController {
    

    @IBOutlet weak var UsernameTextbox: UITextField!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var PasswordCheckTextbox: UITextField!
    @IBOutlet weak var PasswordTextbox: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let InhollandPink = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        
        UsernameTextbox.placeholder = NSLocalizedString("username", comment: "")
        PasswordTextbox.placeholder = NSLocalizedString("password", comment: "")
        PasswordTextbox.isSecureTextEntry = true
        PasswordCheckTextbox.placeholder = NSLocalizedString("cpassword", comment: "")
        PasswordCheckTextbox.isSecureTextEntry = true
        
        NextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        NextButton.backgroundColor = .InhollandPink
        NextButton.tintColor = UIColor.white
       
        NavigationBar.title = NSLocalizedString("register", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        
 }

    @IBAction func RegisterButtonClicked() {
        let username = UsernameTextbox.text!
        var password = ""
        if PasswordTextbox.text == PasswordCheckTextbox.text {
            password = PasswordTextbox.text!
        }
        ApiManager.register(studentid: ((Int)(username) ?? 1), password: password)//.responseData(completionHandler: { [weak self] (response) in
            //let jsonData = response.data!
            //let decoder = JSONDecoder()
            //let sendresult = try? decoder.decode(loginResult.self, from: jsonData)
              //  print(sendresult)
            //})
        
    }
 
}

