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
var latestMessageDate: String = "2000-01-01T00:00:00+0000"
var totalNewMessages = 0

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
        
        if userIsCoach == true{
            if tutorantenOfCoach.count > 0{
                print(tutorantenOfCoach)
                for item in tutorantenOfCoach
                {
                    let studentID = Int(KeychainWrapper.standard.string(forKey: "StudentID")!)
                    CheckLatestMessage(tutorID: tutorantenOfCoach[item], coachID: studentID!)
                }
            }else {
                print("No matches yet...")
            }
        }else if userIsCoach == false{
            let coachID = KeychainWrapper.standard.integer(forKey: "CoachID")
            print(coachID)
            if coachID != nil{
                let studentID = Int(KeychainWrapper.standard.string(forKey: "StudentID")!)
                CheckLatestMessage(tutorID: studentID!, coachID: coachID!)
            }
            else
            {
                print("No matches yet...")
            }
            
        }
        loadnewChats()
        
        
        InboxTableView.separatorStyle = .none
        //MakeApiCall()
        //InboxTableView.reloadData()
       // _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)
    }


func loadnewChats(){
    tutorantenProfiles = []
    let studentID = Int(KeychainWrapper.standard.string(forKey: "StudentID")!)
    var indexnumber = 0
    if userIsCoach == true{
        ApiManager.getTutors(studentID: studentID!).responseData(completionHandler: { [weak self] (response) in

            let jsonData = response.data
            if jsonData != nil{
                let decoder = JSONDecoder()
                let tutorants = try? decoder.decode([Tutorants].self, from: jsonData!)
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
            }
            
            })
    }else
    {
        let coachID = KeychainWrapper.standard.integer(forKey: "CoachID")
        ApiManager.getProfile(studentID: coachID!).responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            Studentprofile = try? decoder.decode(Student.self, from: jsonData)
            tutorantenProfiles.insert(Studentprofile!, at: indexnumber)
            self!.InboxTableView.reloadData()
            UserDefaults.standard.set(tutorantenProfiles.count, forKey: "NumberOfTutoranten")
        })
        self.InboxTableView.reloadData()
    }
    
    
    }
    
    func CheckLatestMessage(tutorID: Int, coachID: Int){
        var NewChat = true
        var NewMessagesReceiver: [Messages] = []
    ApiManager.getMessages(senderID: tutorID , receiverID: coachID).responseData(completionHandler: { [weak self] (responseReceiver) in
        print(responseReceiver.response?.statusCode)
        if responseReceiver.response?.statusCode == 201{
            NewChat = false
            let jsonData = responseReceiver.data!
            let decoder = JSONDecoder()
            NewMessagesReceiver = try! decoder.decode([Messages].self, from: jsonData)
        }
        ApiManager.getMessages(senderID: coachID , receiverID: tutorID).responseData(completionHandler: { [weak self] (responseSender) in
            print(responseReceiver.response?.statusCode)
            if responseReceiver.response?.statusCode == 201{
                NewChat = false
                let jsonData = responseSender.data!
                let decoder = JSONDecoder()
                let NewMessagesSender = try? decoder.decode([Messages].self, from: jsonData)
                let size1 = NewMessagesSender!.count - 1
                let size2 = NewMessagesReceiver.count - 1
                totalNewMessages = (NewMessagesReceiver.count + NewMessagesSender!.count)
                if NewMessagesSender![size1].messageid < NewMessagesReceiver[size2].messageid {
                    LatestMessage = NewMessagesReceiver[size2].payload
                    latestMessageDate = NewMessagesReceiver[size2].created
                }else
                {
                    LatestMessage = NewMessagesSender![size1].payload
                    latestMessageDate = NewMessagesSender![size1].created
                    
                }
                self?.InboxTableView.reloadData()
            }
        })
    })
    
        if NewChat == true{
            LatestMessage = NSLocalizedString("newchat", comment: "")
        }
    }
 
}
 
extension inboxviewcontroller: UITableViewDataSource, UITableViewDelegate{
    
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("tutoranten profile count is: ", tutorantenProfiles.count)
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
            if userIsCoach == true {
                vc.senderID = Int(KeychainWrapper.standard.string(forKey: "StudentID")!)!
                vc.receivedID = tutorantenOfCoach[indexPath.row]
            }else{
                vc.senderID = Int(KeychainWrapper.standard.string(forKey: "StudentID")!)!
                vc.receivedID = KeychainWrapper.standard.integer(forKey: "CoachID")!
            }
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
            
            /*let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "HH:mm"
            let MessDate = dateFormatter.date(from:latestMessageDate)
            */
            let date = latestMessageDate.prefix(10)
            cell.InboxDateLabel.text = String(date)
            
            let NumberOfMessages = UserDefaults.standard.integer(forKey: "MessageAmount")
            if NumberOfMessages < totalNewMessages{
                cell.UnreadMessages = false
            }
            else{
                cell.UnreadMessages = true
            }
            let message = LatestMessage
            let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
            let newMessage = trimmed.data(using: .utf8)
            cell.InboxLatestChat.text = String(data: newMessage!, encoding: .nonLossyASCII)
            
            
            return cell
        }
        
  
       
    
}



