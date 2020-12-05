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

//-----------API NOT WORKING --------------
class NewMessagesArray: Equatable, Hashable{
    static func == (lhs: NewMessagesArray, rhs: NewMessagesArray) -> Bool {
        return lhs.messageid == rhs.messageid && lhs.type == rhs.type && lhs.payload == rhs.payload && lhs.created == rhs.created && lhs.lastmodified == rhs.lastmodified && lhs.senderid == rhs.senderid && lhs.receiverid == rhs.receiverid
    }
        var messageid: Int
        var type: String
        var payload: String
        var created: String
        var lastmodified: String
        var senderid: Int
        var receiverid: Int
    
    init(messageid: Int, type: String, payload: String, created: String, lastmodified: String, senderid: Int, receiverid: Int) {
            self.messageid = messageid
            self.type = type
            self.payload = payload
            self.created = created
            self.lastmodified = lastmodified
            self.senderid = senderid
            self.receiverid = receiverid
        }

    var hashValue: Int {
            get {
                return messageid.hashValue + type.hashValue + payload.hashValue + created.hashValue + lastmodified.hashValue + senderid.hashValue + receiverid.hashValue
            }
        }
}

class ChatsArray: Equatable, Hashable{
    static func == (lhs: ChatsArray, rhs: ChatsArray) -> Bool {
        return lhs.studentID == rhs.studentID && lhs.coachID == rhs.coachID && lhs.messages == rhs.messages
    }
    
    var studentID: String
    var coachID: String
    var messages: [NewMessagesArray]
    
    init(studentID: String, coachID: String, messages: [NewMessagesArray]) {
            self.studentID = studentID
            self.coachID = coachID
            self.messages = messages
        }

    var hashValue: Int {
            get {
                return studentID.hashValue + coachID.hashValue + messages.hashValue
            }
        }
}



var MessageArray: [Messages] = []

var testarray: [Int] = [1,2,3,4,5]
var dates: [String] = []
var messagesNumber: [Int] = []
var messagesPerDate: [Int] = []
var firstload: Bool = true
var shownMessages: Int = 0
let userDefaults = UserDefaults.standard
var ScrollToBottom = true
var NewMessages = false


class messagesviewcontroller: UIViewController {
    
    @IBOutlet weak var NewMessageView: UIView!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var NewMessageTextbox: UITextField!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MessagesTableView: UITableView!
    var ChatName: String = ""
    var senderID: Int = 0
    var receivedID: Int = 0
    
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
        print("Senderid is:", senderID, "receiverID is: ", receivedID)
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
                var lastSection = 0
                var lastRow = 0
                if self.MessagesTableView.numberOfSections >= 1{
                    lastSection = (self.MessagesTableView.numberOfSections - 1)
                }
                if lastSection >= 1 {
                    lastRow = (self.MessagesTableView.numberOfRows(inSection: lastSection) - 1)
                }
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
        ApiManager.SendMessage(senderid: senderID, payload: newMessage!, receiverid: receivedID).responseData(completionHandler: { (response) in
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
    var NewMessagesSender: [Messages] = []
    var NewMessagesReceiver: [Messages] = []
    ApiManager.getMessages(senderID: senderID , receiverID: receivedID).responseData(completionHandler: { [weak self] (responseReceiver) in
        if responseReceiver.response?.statusCode == 200{
            NewMessages = true
            let jsonData = responseReceiver.data!
            let decoder = JSONDecoder()
            NewMessagesReceiver = try! decoder.decode([Messages].self, from: jsonData)
        }
            ApiManager.getMessages(senderID: self!.receivedID , receiverID: self!.senderID).responseData(completionHandler: { [weak self] (responseSender) in
                if responseSender.response?.statusCode == 200{
                    NewMessages = true
                    let jsonData = responseSender.data!
                    let decoder = JSONDecoder()
                    NewMessagesSender = try! decoder.decode([Messages].self, from: jsonData)
                }
                
                let totalMessages = (NewMessagesSender.count + NewMessagesReceiver.count)
                print("total messages :",NewMessagesSender.count, NewMessagesReceiver.count)
                UserDefaults.standard.set(totalMessages, forKey: "MessageAmount")
                    
                    
                    if (NewMessagesSender != nil && NewMessagesReceiver != nil){
                        var counter = 0
                        while counter < totalMessages{
                            if SSize < NewMessagesSender.count && RSize < NewMessagesReceiver.count {
                                if NewMessagesSender[SSize].messageid < NewMessagesReceiver[RSize].messageid {
                                    MessageArray.append(NewMessagesSender[SSize])
                                    //print(NewMessagesSender![SSize].messageid)
                                    print("Ssize is: ", SSize)
                                    if SSize < NewMessagesSender.count{
                                    SSize = SSize + 1
                                    counter = counter + 1
                                    }
                                
                                }else if (NewMessagesSender[SSize].messageid > NewMessagesReceiver[RSize].messageid)// && (NewMessagesReceiver![RSize].messageid < NewMessagesSender![SSize + 1].messageid )  {
                                {
                                    MessageArray.append(NewMessagesReceiver[RSize])
                                    //print(NewMessagesReceiver![RSize].messageid)
                                    print("Rsize is : ", RSize)
                                    if RSize < NewMessagesReceiver.count{
                                    RSize = RSize + 1
                                    counter = counter + 1
                                    }
                                
                                }
                            }
                            else if SSize < NewMessagesSender.count {
                                MessageArray.append(NewMessagesSender[SSize])
                                //print(NewMessagesSender![SSize].messageid)
                                print("Ssize is: ", SSize)
                                if SSize < NewMessagesSender.count{
                                SSize = SSize + 1
                                counter = counter + 1
                                }
                                
                            }
                            else if RSize < NewMessagesReceiver.count {
                                MessageArray.append(NewMessagesReceiver[RSize])
                                //print(NewMessagesReceiver![RSize].messageid)
                                print("Rsize is : ", RSize)
                                if RSize < NewMessagesReceiver.count{
                                RSize = RSize + 1
                                counter = counter + 1
                                }
                                    
                            }
                            else{
                                print("Ssize : ", SSize, "Rsize : ", RSize)
                                break
                            }
                        
                        }
                        
                    self!.LoadingIndicator.stopAnimating()
                    self!.LoadingIndicator.isHidden = true
                    self!.MessagesTableView.reloadData()
                        
                    if ScrollToBottom == true && NewMessages == true{
                        
                    let lastSection: Int = (self!.MessagesTableView.numberOfSections - 1)
                    let lastRow: Int = (self!.MessagesTableView.numberOfRows(inSection: lastSection) - 1)
                    print("lastrow is: \(lastRow), lastsection is: \(lastSection)")
                    self!.MessagesTableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: false)
                
                    }
                   
                }else {print("messages is nul")}
            })
    })

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
        for i in 0...(sizeofarray - 1) {
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
                if senderID == MessageArray[cellnumber].senderid {
                    cell.incomming = false
                }else if receivedID == MessageArray[cellnumber].senderid {
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
