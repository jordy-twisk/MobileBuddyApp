//
//  HomeViewController.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import UIKit
import SAConfettiView

var newMessages: Bool = false
var numberOfTutorants: Int = UserDefaults.standard.integer(forKey: "NumberOfTutoranten")

struct NewNotifications {
    var type: String
    var payload: String
    var created: Date
    init(type: String, payload: String, created: Date) {
        self.type = type
        self.payload = payload
        self.created = created
    }
}
var NewNotificationsMessages: [NewNotifications] = []



class homeviewcontroller: UIViewController {
//UserDefaults.standard.set(tutorantenProfiles.count, forKey: "NumberOfTutoranten")
     
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var TableView: UITableView!
    var turorants: [String] = []
    override func viewDidLoad() {
    super.viewDidLoad()

        self.TableView.delegate = self
        self.TableView.dataSource = self
        NavigationBar.title = NSLocalizedString("home", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        
        checknewmessages()
        print("Number of tutorqnts is: ",numberOfTutorants)
        checkTutoranten()
        self.TableView.dataSource = self as UITableViewDataSource
        self.TableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")

        }
    
    func checkTutoranten(){
        ApiManager.getTutors(studentID: 31214).responseData(completionHandler: { [weak self] (response) in
            let jsonData = response.data
            if jsonData != nil {
                let decoder = JSONDecoder()
                let tutorants = try? decoder.decode([Tutorants].self, from: jsonData!)
                let newtutor = NewNotifications(type: NSLocalizedString("newtutortype", comment: ""), payload: NSLocalizedString("newtutortext", comment: ""), created: Date())
                
                print("new tutors is:", tutorants!.count)
                if numberOfTutorants < tutorants!.count{
                    newMessages = true
                    NewNotificationsMessages.append(newtutor)
                   // self!.NewTutorantMessage()
                    self!.TableView.reloadData()
                }
            }
            
            })
        
                
        }
    
    func NewTutorantMessage(){
        //let confettiView = SAConfettiView(frame: self.view.bounds)
        //confettiView.type = .Confetti
        //confettiView.colors = [UIColor.InhollandPink, UIColor.purple, UIColor.red]
        //confettiView.intensity = 1
        //self.view.addSubview(confettiView)
        //confettiView.startConfetti()
        let alert = UIAlertController(title: NSLocalizedString("NewTutorTitle", comment: ""), message: NSLocalizedString("NewTutorMSG", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "") , style: .default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            //confettiView.stopConfetti()
//            repeat {
//
//            }while (confettiView.isActive() == true)
//            confettiView.removeFromSuperview()
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
     func checknewmessages() {
        
            ApiManager.getMessages(senderID: 710 , receiverID: 701).responseData(completionHandler: { [weak self] (responseReceiver) in
                let jsonData = responseReceiver.data!
                let decoder = JSONDecoder()
                let messagesreceiver = try? decoder.decode([Messages].self, from: jsonData)
                ApiManager.getMessages(senderID: 701 , receiverID: 710).responseData(completionHandler: { [weak self] (responseSender) in
                    let jsonData = responseSender.data!
                    let decoder = JSONDecoder()
                    let NewMessagesSender = try? decoder.decode([Messages].self, from: jsonData)
                    let NumberOfMessages = UserDefaults.standard.integer(forKey: "MessageAmount")
                    let totalNewMessages = messagesreceiver!.count + NewMessagesSender!.count
                    print("current messages is: ", NumberOfMessages)
                    print("new messages? ", totalNewMessages )
                    if totalNewMessages > NumberOfMessages{
                        newMessages = true
                        let newMessage = NewNotifications(type: NSLocalizedString("newMessagetype", comment: ""), payload: NSLocalizedString("newMessagetext", comment: ""), created: Date())
                        NewNotificationsMessages.append(newMessage)
                    }
                self!.TableView.reloadData()
                
            })
        })
    }
}

   

    extension homeviewcontroller: UITableViewDataSource, UITableViewDelegate{
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return NewNotificationsMessages.count
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print(indexPath)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "inboxviewcontroller") as! inboxviewcontroller
            navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell",
            for: indexPath) as! HomeTableViewCell
            //cell.Label.text = MyObjects[indexPath.row].description
            if newMessages == true{
                let dateInput = NewNotificationsMessages[indexPath.row].created
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                cell.NotificationDate.text = formatter.string(from: dateInput)
                cell.Notification.text = NewNotificationsMessages[indexPath.row].payload
            }
                        return cell
        }
}

 

