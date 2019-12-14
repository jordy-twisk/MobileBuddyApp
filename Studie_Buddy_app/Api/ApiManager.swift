//
//  ApiManager.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper


final class ApiManager{
    
    static var BaseURL = "http://192.168.178.227:7071/"
    
    static func getMessages() -> DataRequest{
        return Alamofire.request(BaseURL + "api/messages/701/710", method: .get)
    }
    
    static func getProfile() -> DataRequest{
        
        return Alamofire.request(BaseURL + "api/student/123456", method: .get)
    }
    
    static func LogUserIn(username: String, password: String) -> DataRequest{
        let parameters: [String : Any] = [
                "studentID": "\(username)",
                "password": "\(password)"
        ]
        return Alamofire.request(BaseURL + "api/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    static func register(studentid: Int, password: String) -> DataRequest{
        let parameters: [String : Any] = [
                "AuthID": 12,
                "AuthToken": "80-B6-87-8C-CE-78-D7-48A0-70-2A-77-22-46-BE-4F-AC-6E-31-81-D7-EE-58-5467-EC-CF-7A-42-BE-CD-67-74-2B",
                "studentID": studentid,
                "password": "\(password)",
                "role": 2
        ]
        return Alamofire.request(BaseURL + "api/auth/register", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    
    
    static func SendMessage(senderid: Int, payload: String, receiverid: Int) -> DataRequest{
        let parameters: [String : Any] = [
                "messageID": 1,
                "type": "text",
                "payload": "\(payload)",
                "created": "10/12/2019",
                "lastModified": "10/12/2019",
                "senderID": (senderid),
                "receiverID": (receiverid)
        ]
        return Alamofire.request(BaseURL + "api/message",method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
}
 

