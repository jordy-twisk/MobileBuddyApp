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
//import SwiftyJSON

var MessageArray: [Messages] = []

var testarray: [Int] = [1,2,3,4,5]
var dates: [String] = []
var messagesNumber: [Int] = []
var messagesPerDate: [Int] = []
var userid: Int = 701
var receivedfrom: Int = 710
var firstload: Bool = true

var shownMessages: Int = 0
let userDefaults = UserDefaults.standard
var ScrollToBottom = true


class messagesviewcontroller: UIViewController {
    
    @IBOutlet weak var NewMessageView: UIView!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var NewMessageTextbox: UITextField!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MessagesTableView: UITableView!
    var ChatName: String = ""
    
    var bottomconstraint: NSLayoutConstraint?
    override func viewDidLoad() {
    super.viewDidLoad()
      
        
        self.MessagesTableView.dataSource = self
        self.MessagesTableView.delegate = self
        self.MessagesTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.title = ChatName
        MessagesTableView.separatorStyle = .none
        LoadingIndicator.startAnimating()
        LoadingIndicator.isHidden = false
        MakeApiCall()
        //Makeprofilecall()
        SendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        NewMessageTextbox.placeholder = NSLocalizedString("newmessage", comment: "")
        MessagesTableView.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)

        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bottomconstraint = NSLayoutConstraint(item: NewMessageView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomconstraint!)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
   
    @objc func handleKeyboardNotification(notifcation: NSNotification){
        if let userinfo = notifcation.userInfo {
            let keyboardframe = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardshowing = notifcation.name == UIResponder.keyboardWillShowNotification
            bottomconstraint?.constant = isKeyboardshowing ? -keyboardframe!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            }, completion:{ (completed) in
                    let lastSection: Int = (self.MessagesTableView.numberOfSections - 1)
                    let lastRow: Int = (self.MessagesTableView.numberOfRows(inSection: lastSection) - 1)
                    self.MessagesTableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: false)
                
            })
        }
    }
    
    @objc func execute() {
        ScrollToBottom = false
        MakeApiCall()
    }

    @IBAction func SendButtonClicked() {
        let textmessage = NewMessageTextbox.text
        if textmessage != ""
        {
        let message = textmessage!.data(using: .nonLossyASCII)
        let newMessage = String(data: message!, encoding: .utf8)
            print("new message is: ", newMessage!)
        ApiManager.SendMessage(senderid: 701, payload: newMessage!, receiverid: 710).responseData(completionHandler: { (response) in
           // let jsonData = response.data!
            //let decoder = JSONDecoder()
            //let sendresult = try? decoder.decode(Data.self, from: jsonData)
            //print("sendresult is: ",sendresult as Any)
            })
        NewMessageTextbox.text = ""
        ScrollToBottom = true
        MakeApiCall()
        }
    }

    

func MakeApiCall(){
    MessageArray = []
    var SSize = 0
    var RSize = 0
    ApiManager.getMessages(senderID: 710 , receiverID: 701).responseData(completionHandler: { [weak self] (responseReceiver) in
        let jsonData = responseReceiver.data!
        let decoder = JSONDecoder()
        let NewMessagesReceiver = try? decoder.decode([Messages].self, from: jsonData)
        ApiManager.getMessages(senderID: 701 , receiverID: 710).responseData(completionHandler: { [weak self] (responseSender) in
            let jsonData = responseSender.data!
            let decoder = JSONDecoder()
            let NewMessagesSender = try? decoder.decode([Messages].self, from: jsonData)
            let totalMessages = (NewMessagesSender!.count + NewMessagesReceiver!.count)
            print("total messages :",NewMessagesSender!.count, NewMessagesReceiver!.count)
            UserDefaults.standard.set(totalMessages, forKey: "MessageAmount")
            
            
            if (NewMessagesSender != nil && NewMessagesReceiver != nil){
                var counter = 0
                while counter < totalMessages{
                    if SSize < NewMessagesSender!.count && RSize < NewMessagesReceiver!.count {
                        if NewMessagesSender![SSize].messageid < NewMessagesReceiver![RSize].messageid {
                            MessageArray.append(NewMessagesSender![SSize])
                            //print(NewMessagesSender![SSize].messageid)
                            print("Ssize is: ", SSize)
                            if SSize < NewMessagesSender!.count{
                            SSize = SSize + 1
                            counter = counter + 1
                            }
                        
                        }else if (NewMessagesSender![SSize].messageid > NewMessagesReceiver![RSize].messageid)// && (NewMessagesReceiver![RSize].messageid < NewMessagesSender![SSize + 1].messageid )  {
                        {
                            MessageArray.append(NewMessagesReceiver![RSize])
                            //print(NewMessagesReceiver![RSize].messageid)
                            print("Rsize is : ", RSize)
                            if RSize < NewMessagesReceiver!.count{
                            RSize = RSize + 1
                            counter = counter + 1
                            }
                        
                        }
                    }
                    else if SSize < NewMessagesSender!.count {
                        MessageArray.append(NewMessagesSender![SSize])
                        //print(NewMessagesSender![SSize].messageid)
                        print("Ssize is: ", SSize)
                        if SSize < NewMessagesSender!.count{
                        SSize = SSize + 1
                        counter = counter + 1
                        }
                        
                    }
                    else if RSize < NewMessagesReceiver!.count {
                        MessageArray.append(NewMessagesReceiver![RSize])
                        //print(NewMessagesReceiver![RSize].messageid)
                        print("Rsize is : ", RSize)
                        if RSize < NewMessagesReceiver!.count{
                        RSize = RSize + 1
                        counter = counter + 1
                        }
                            
                    }
                    else{
                        print("Ssize : ", SSize, "Rsize : ", RSize)
                        break
                    }
                
                        
                    /*}else if (NewMessagesSender![SSize].messageid > NewMessagesReceiver![RSize].messageid)
                    {
                        MessageArray.append(NewMessagesReceiver![RSize])
                        print(NewMessagesReceiver![RSize].messageid)
                        RSize = RSize + 1
                    }
                         */
                        
                   
                }
                /*
                if SSize < NewMessagesSender!.count{
                MessageArray.append(NewMessagesSender![SSize])
                print(NewMessagesSender![SSize].messageid)
                counter = counter + 1
                SSize = SSize + 1
                }
                */
            
           /*
            if (NewMessagesSender != nil && NewMessagesReceiver != nil){
                while SSize < NewMessagesSender!.count {
                    while RSize < NewMessagesReceiver!.count {
                        if SSize < NewMessagesSender!.count {
                            if NewMessagesSender![SSize].messageid < NewMessagesReceiver![RSize].messageid {
                                MessageArray.append(NewMessagesSender![SSize])
                                //print(NewMessagesSender![SSize].messageid)
                                print("Ssize is: ", SSize)
                                if SSize < NewMessagesSender!.count{
                                SSize = SSize + 1
                                }
                            
                            }else if (NewMessagesSender![SSize].messageid > NewMessagesReceiver![RSize].messageid)// && (NewMessagesReceiver![RSize].messageid < NewMessagesSender![SSize + 1].messageid )  {
                            {
                                MessageArray.append(NewMessagesReceiver![RSize])
                                //print(NewMessagesReceiver![RSize].messageid)
                                print("Rsize is : ", RSize)
                                if RSize < NewMessagesReceiver!.count{
                                RSize = RSize + 1
                                }
                            
                            }
                        /*}else if (NewMessagesSender![SSize].messageid > NewMessagesReceiver![RSize].messageid)
                        {
                            MessageArray.append(NewMessagesReceiver![RSize])
                            print(NewMessagesReceiver![RSize].messageid)
                            RSize = RSize + 1
                        }
                             */                 }
                       else if RSize < NewMessagesReceiver!.count{
                            if (NewMessagesSender![SSize].messageid > NewMessagesReceiver![RSize].messageid)// && (NewMessagesReceiver![RSize].messageid < NewMessagesSender![SSize + 1].messageid )  {
                            {
                                MessageArray.append(NewMessagesReceiver![RSize])
                                //print(NewMessagesReceiver![RSize].messageid)
                                print("Rsize is : ", RSize)
                                if RSize < NewMessagesReceiver!.count{
                                RSize = RSize + 1
                                }
                            
                            }
                        }
                        else{
                            break
                        }
                    }
                    if SSize < NewMessagesSender!.count{
                    MessageArray.append(NewMessagesSender![SSize])
                    print(NewMessagesSender![SSize].messageid)
                    
                    SSize = SSize + 1
                    }
                    
                }
 
*/
           // UserDefaults.standard.set(MessageArray.count, forKey: "MessageAmount")
            //UserDefaults.standard.set(MessageArray[MessageArray.count - 1], forKey: "LastMessage")
                
            self!.LoadingIndicator.stopAnimating()
            self!.LoadingIndicator.isHidden = true
            self!.MessagesTableView.reloadData()
                
            if ScrollToBottom == true {
                
            let lastSection: Int = (self!.MessagesTableView.numberOfSections - 1)
            let lastRow: Int = (self!.MessagesTableView.numberOfRows(inSection: lastSection) - 1)
            print("lastrow is: \(lastRow), lastsection is: \(lastSection)")
            self!.MessagesTableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: false)
        
            }
            //UserDefaults.standard.set(MessageArray, forKey: "Messages")
            //let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: MessageArray, requiringSecureCoding: true)
            //userDefaults.set(encodedData, forKey: "Messages")
            //userDefaults.synchronize()
            
            //let name = UserDefaults.standard.string(forKey: "Messages")
        }else {print("messages is nul")}

    })})
    
    }
}
extension messagesviewcontroller: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sizeofarray = 1
        var numberofdates = 0
        var messagesOfDate = 1
        if MessageArray.count != 0{
        sizeofarray = MessageArray.count
        var date = MessageArray[0].created
        dates.insert("\(date)", at: numberofdates)
        messagesNumber.insert(0, at: numberofdates)
        numberofdates = numberofdates + 1
        for i in 1...(sizeofarray - 1) {
            if MessageArray[i].created != date{
                date = MessageArray[i].created
                dates.insert("\(date)", at: numberofdates)
                messagesPerDate.insert(messagesOfDate, at: numberofdates - 1)
                messagesNumber.insert(i, at: numberofdates)
                numberofdates = numberofdates + 1
                messagesOfDate = 1
                
                
            }else{
                messagesOfDate = messagesOfDate + 1
                
                
            }
            
        }
           messagesPerDate.insert(messagesOfDate, at: numberofdates - 1)
        }
        return numberofdates
    }

    class dateHeaderLabel: UILabel {
        override var intrinsicContentSize: CGSize{
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    func tableView(_ tableView: UITableView,
                               viewForHeaderInSection section: Int) -> UIView? {
        let label = dateHeaderLabel()
        label.backgroundColor = .InhollandPink
        let dateInput = dates[section]
        let date = dateInput.prefix(10)
        label.text = String(date)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
            
        let containerView = UIView()
        
        containerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection: Int = (self.MessagesTableView.numberOfSections - 1)
        let lastRow: Int = (self.MessagesTableView.numberOfRows(inSection: lastSection) - 1)
        if indexPath.row + 1 == lastRow {
            ScrollToBottom = true
           }
        else{
            ScrollToBottom = false
        }
       }
       
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return  messagesPerDate[section]
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell",
            for: indexPath) as! MessageTableViewCell
            let cellnumber = indexPath.row + messagesNumber[indexPath.section]
            if cellnumber < MessageArray.count {
                if userid == MessageArray[cellnumber].senderid {
                    cell.incomming = false
                }else if receivedfrom == MessageArray[cellnumber].senderid {
                    cell.incomming = true
                }
                let message = MessageArray[cellnumber].payload
                let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
                let newMessage = trimmed.data(using: .utf8)
                cell.MessagePayloadLabel.text = String(data: newMessage!, encoding: .nonLossyASCII)
            }
            return cell
        }
}
