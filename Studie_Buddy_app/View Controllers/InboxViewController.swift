//
//  MessagesViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire
import SwiftKeychainWrapper


var tutoranten: [Tutorants] = []
var tutorantenProfiles: [Student] = []
var LatestMessage: String = ""

class inboxviewcontroller: UIViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var InboxTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InboxTableView.dataSource = self
        self.InboxTableView.delegate = self
        self.InboxTableView.register(UINib(nibName: "InboxTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxTableViewCell")
        
        NavigationBar.title = NSLocalizedString("inbox", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        loadnewtutorants()
        CheckLatestMessage()
        
        InboxTableView.separatorStyle = .none
        //MakeApiCall()
        //InboxTableView.reloadData()
       // _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)
    }


func loadnewtutorants(){
    tutorantenProfiles = []
    var indexnumber = 0
    ApiManager.getTutors(studentID: 31214).responseData(completionHandler: { [weak self] (response) in
        let jsonData = response.data!
        let decoder = JSONDecoder()
        let tutorants = try? decoder.decode([Tutorants].self, from: jsonData)
        if tutorants != nil {
            for item in tutorants!{
                tutoranten.append(item)
                print(item.tutorantid)
            }
            for i in 0...tutoranten.count - 1  {
              

                ApiManager.getProfile(studentID: tutoranten[i].tutorantid).responseData(completionHandler: { [weak self] (response) in
                let jsonData = response.data!
                let decoder = JSONDecoder()
                Studentprofile = try? decoder.decode(Student.self, from: jsonData)
                   // print(Studentprofile!.firstname)
                if indexnumber < UserDefaults.standard.integer(forKey: "NumberOfTutoranten") || UserDefaults.standard.integer(forKey: "NumberOfTutoranten") == 0 {
                tutorantenProfiles.insert(Studentprofile!, at: indexnumber)
                    indexnumber = indexnumber + 1
                    }
                    //print("count is:",tutorantenProfiles.count)
                        self!.InboxTableView.reloadData()
                    UserDefaults.standard.set(tutorantenProfiles.count, forKey: "NumberOfTutoranten")
                })
                
            }
            self?.InboxTableView.reloadData()
            
        }
        })
    
    }
    
    func CheckLatestMessage(){
    ApiManager.getMessages(senderID: 710 , receiverID: 701).responseData(completionHandler: { [weak self] (responseReceiver) in
        let jsonData = responseReceiver.data!
        let decoder = JSONDecoder()
        let NewMessagesReceiver = try? decoder.decode([Messages].self, from: jsonData)
        ApiManager.getMessages(senderID: 701 , receiverID: 710).responseData(completionHandler: { [weak self] (responseSender) in
            let jsonData = responseSender.data!
            let decoder = JSONDecoder()
            let NewMessagesSender = try? decoder.decode([Messages].self, from: jsonData)
            let size1 = NewMessagesSender!.count - 1
            let size2 = NewMessagesReceiver!.count - 1
            if NewMessagesSender![size1].messageid < NewMessagesReceiver![size2].messageid {
                LatestMessage = NewMessagesReceiver![size2].payload
            }else
            {
                LatestMessage = NewMessagesSender![size1].payload
            }
            self?.InboxTableView.reloadData()
        })
    })
    
    }
 
}
 
extension inboxviewcontroller: UITableViewDataSource, UITableViewDelegate{
    
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(tutorantenProfiles.count)
            return  tutorantenProfiles.count
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print(indexPath)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "messagesviewcontroller") as! messagesviewcontroller
            vc.ChatName = tutorantenProfiles[indexPath.row].firstname
            navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell",
            for: indexPath) as! InboxTableViewCell
            cell.InboxProfileImage.image = UIImage(named: "Profile")
            print("tutoranten profiles count is :", tutorantenProfiles.count)
            if tutorantenProfiles.count != 0 {
            cell.InboxChatName.text = tutorantenProfiles[indexPath.row].firstname
            }
            cell.InboxDateLabel.text = "8/1/2020"
            let message = LatestMessage
            let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
            let newMessage = trimmed.data(using: .utf8)
            cell.InboxLatestChat.text = String(data: newMessage!, encoding: .nonLossyASCII)
            
            
            return cell
        }
        
  
       
    
}



