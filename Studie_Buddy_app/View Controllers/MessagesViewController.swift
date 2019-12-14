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

var MessageArray: [Messages] = []

var testarray: [Int] = [1,2,3,4,5]

var userid: Int = 701
var receivedfrom: Int = 710
var datenames: [String] = []
var firstload: Bool = true

class messagesviewcontroller: UIViewController {
    
    @IBOutlet weak var NewMessageView: UIView!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var NewMessageTextbox: UITextField!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MessagesTableView: UITableView!
    
    var bottomconstraint: NSLayoutConstraint?
    override func viewDidLoad() {
    super.viewDidLoad()
        self.MessagesTableView.dataSource = self
        self.MessagesTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        self.navigationController!.navigationBar.largeContentTitle = NSLocalizedString("messages", comment: "")
    self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.view.backgroundColor = .clear
        MessagesTableView.separatorStyle = .none
        LoadingIndicator.startAnimating()
        LoadingIndicator.isHidden = false
       MakeApiCall()
        SendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        NewMessageTextbox.placeholder = NSLocalizedString("newmessage", comment: "")
        MessagesTableView.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)

        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bottomconstraint = NSLayoutConstraint(item: NewMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomconstraint!)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleKeyboardNotification(notifcation: NSNotification){
        if let userinfo = notifcation.userInfo {
            let keyboardframe = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            print(keyboardframe)
            
            let isKeyboardshowing = notifcation.name == UIResponder.keyboardWillShowNotification
            bottomconstraint?.constant = isKeyboardshowing ? -keyboardframe!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            }, completion:{ (completed) in
                let indexpath = IndexPath(item: self.MessagesTableView.numberOfRows(inSection: 0) - 1, section: 0)
                self.MessagesTableView.scrollToRow(at: indexpath, at: .bottom, animated: true)
            })
        }
    }
    
    @objc func execute() {
        ApiManager.getMessages().responseData(completionHandler: { [weak self] (response) in
        let jsonData = response.data!
        let decoder = JSONDecoder()
        let NewMessages = try? decoder.decode([Messages].self, from: jsonData)
        if NewMessages != nil {
            MessageArray = []
            for item in NewMessages!{
                MessageArray.append(item)
            }
            //let defaults = UserDefaults.standard
            //defaults.set(MessageArray, forKey: "Offline_Chats")
            self!.LoadingIndicator.stopAnimating()
            self!.LoadingIndicator.isHidden = true
            self!.MessagesTableView.reloadData()
            let lastRow: Int = self!.MessagesTableView.numberOfRows(inSection: 0) - 1
            self!.MessagesTableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: false)



        }
        })
    }

    @IBAction func SendButtonClicked() {
        let textmessage = NewMessageTextbox.text
        if textmessage != "" {
        ApiManager.SendMessage(senderid: 701, payload: textmessage!, receiverid: 710).responseData(completionHandler: { (response) in
            let jsonData = response.data!
            let decoder = JSONDecoder()
            let sendresult = try? decoder.decode(Data.self, from: jsonData)
            //print(sendresult)
            })
        NewMessageTextbox.text = ""
        MakeApiCall()
        }
    }

    

func MakeApiCall(){

    ApiManager.getMessages().responseData(completionHandler: { [weak self] (response) in
        let jsonData = response.data!
        let decoder = JSONDecoder()
        let NewMessages = try? decoder.decode([Messages].self, from: jsonData)
        if NewMessages != nil {
            for item in NewMessages!{
                MessageArray.append(item)
            }
            self!.LoadingIndicator.stopAnimating()
            self!.LoadingIndicator.isHidden = true
            self!.MessagesTableView.reloadData()
            let lastRow: Int = self!.MessagesTableView.numberOfRows(inSection: 0) - 1
            self!.MessagesTableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: false)

        }
        })
    
    }
}
extension messagesviewcontroller: UITableViewDataSource{
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        var sizeofarray = 1
        var numberofdates = 0
        var date = ""
        if MessageArray.count != 0{
        sizeofarray = MessageArray.count
        for i in 0...(sizeofarray - 1) {
            if MessageArray[i].created == date{
                print("same date")
            }else{
                date = MessageArray[i].created
                numberofdates = numberofdates + 1
                print(numberofdates)
            }
            
        }
        }
        return numberofdates
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section\(section)"
    }
     */
    
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(MessageArray.count)
            return  MessageArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell",
            for: indexPath) as! MessageTableViewCell
            //if firstload == true{
                //firstload = false
              //  let defaults = UserDefaults.standard
                //let LoadMessages: [Messages] = defaults.array(forKey: "Offline_Chats") as! [Messages]
                //if userid == LoadMessages[indexPath.row].senderid {
                  //  cell.incomming = false
                //}else if receivedfrom == LoadMessages[indexPath.row].senderid {
                //    cell.incomming = true
               // }
               // cell.MessagePayloadLabel.text = MessageArray[indexPath.row].payload
                
            //}else {
                if userid == MessageArray[indexPath.row].senderid {
                    cell.incomming = false
                }else if receivedfrom == MessageArray[indexPath.row].senderid {
                    cell.incomming = true
                }
                cell.MessagePayloadLabel.text = MessageArray[indexPath.row].payload
           //}
            return cell
        }
}



