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

let NewIncomingMessages: [String] = ["Hoi", "Wat doe je", "NieuwBericht", "Test", "Dit is bericht 5", "Kijk dit eens", "Wow wat is dir gaaf he zou je echt eens moeten zien", "de laatste"]
let Names: [String] = ["piet", "jan", "willem", "Mark", "david", "sara", "ida", "Erik"]
let Date: String = "22/12/19"
let Unread: [Int] = [0,0,0,0,1,2,3,4
]
class inboxviewcontroller: UIViewController {
    
    @IBOutlet weak var InboxTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InboxTableView.dataSource = self
        self.InboxTableView.register(UINib(nibName: "InboxTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxTableViewCell")
        
        self.navigationController!.navigationBar.largeContentTitle = NSLocalizedString("messages", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Header4"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
        
        InboxTableView.separatorStyle = .none
        //MakeApiCall()
        InboxTableView.reloadData()
       // _ = Timer.scheduledTimer(timeInterval: 5.0,target: self,selector: #selector(execute),userInfo: nil,repeats: true)
    }
/*

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
 */
}
 
extension inboxviewcontroller: UITableViewDataSource{
    
        func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(NewIncomingMessages.count)
            return  NewIncomingMessages.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell",
            for: indexPath) as! InboxTableViewCell
            cell.InboxChatName.text = Names[indexPath.row]
            cell.InboxDateLabel.text = Date
            cell.NewMessagesLabel.text = (String)(Unread[indexPath.row])
            cell.InboxLatestChat.text = NewIncomingMessages[indexPath.row]
            return cell
        }
}



