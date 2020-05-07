//
//  ApiManager.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//
/*
pod 'Alamofire'
pod 'Kingfisher'
pod 'SwiftKeychainWrapper'
pod 'Fabric'
pod 'SwiftyJSON'
pod 'SAConfettiView'

*/

import Foundation
import Alamofire
import SwiftKeychainWrapper


final class ApiManager{
    
    static var BaseURL = "https://dev-tinderclonefa-test.azurewebsites.net/"
    
    static func getMessages(senderID: Int , receiverID: Int) -> DataRequest{
        let authToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let authID = KeychainWrapper.standard.string(forKey: "StudentID")
        let headers: HTTPHeaders = [
        "AuthToken": "\(authToken!)",
        "AuthID": "\(authID!)"
        ]
        return AF.request(BaseURL + "api/messages/\(senderID)/\(receiverID)", method: .get, headers: headers)
    }
    
    static func getTutors(studentID: Int) -> DataRequest{
        let authToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let authID = KeychainWrapper.standard.string(forKey: "StudentID")
        let headers: HTTPHeaders = [
        "AuthToken": "\(authToken!)",
        "AuthID": "\(authID!)"
        ]
        return AF.request(BaseURL + "api/coachTutorant/coach/\(studentID)", method: .get, headers: headers)
    }
    
    static func getProfile(studentID: Int) -> DataRequest{
        let authToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let authID = KeychainWrapper.standard.string(forKey: "StudentID")
        let headers: HTTPHeaders = [
        "AuthToken": "\(authToken!)",
        "AuthID": "\(authID!)"
        ]
        return AF.request(BaseURL + "api/student/\(studentID)", method: .get, headers: headers)
    }
    
    static func getCoaches() -> DataRequest{
        let authToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let authID = KeychainWrapper.standard.string(forKey: "StudentID")
        let headers: HTTPHeaders = [
        "AuthToken": "\(authToken!)",
        "AuthID": "\(authID!)"
        ]
        return AF.request(BaseURL + "api/profile/coach", method: .get, headers: headers)
    }
    
    static func updateProfile(student: Student) -> DataRequest{
        let authToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let authID = KeychainWrapper.standard.string(forKey: "StudentID")
        let headers: HTTPHeaders  = [
        "AuthToken": "\(authToken!)",
        "AuthID": "\(authID!)"
        ]
        let parameters: [String : String] = [
            "studentID": "\(student.studentid)",
            "firstName": "\(student.firstname)",
            "surName": "\(student.surname)",
            "phoneNumber": "\(student.phonenumber)",
            "photo": "\(student.photo)",
            "description": "\(student.description)",
            "degree": "\(student.degree)",
            "study": "\(student.study)",
            "studyYear": "\(student.studyyear)",
            "interests": "\(student.interests)"
        ]
        return AF.request(BaseURL + "api/student/\(student.studentid)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
    
    static func LogUserIn(username: String, password: String) -> DataRequest{
        let parameters: [String : String] = [
                "studentID": "\(username)",
                "password": "\(password)"
        ]
        return AF.request(BaseURL + "api/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    static func register(studentid: Int, password: String) -> DataRequest{
        let parameters: [String : Any] = [
                "AuthID": 12,
                "AuthToken": "80-B6-87-8C-CE-78-D7-48A0-70-2A-77-22-46-BE-4F-AC-6E-31-81-D7-EE-58-5467-EC-CF-7A-42-BE-CD-67-74-2B",
                "studentID": studentid,
                "password": "\(password)",
                "role": 2
        ]
        return AF.request(BaseURL + "api/auth/register", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    
    
    static func SendMessage(senderid: Int, payload: String, receiverid: Int) -> DataRequest{
        let authToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        let authID = KeychainWrapper.standard.string(forKey: "StudentID")
        let headers: HTTPHeaders = [
        "AuthToken": "\(authToken!)",
        "AuthID": "\(authID!)"
        ]
        let parameters: [String : Any] = [
                "type": "text",
                "payload": "\(payload)",
                "created": "10/12/2019",
                "lastModified": "10/12/2019",
                "senderID": (senderid),
                "receiverID": (receiverid)
        ]
        return AF.request(BaseURL + "api/message",method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
    
    static func SaveImage (ImageUrl: URL) -> DataRequest{
        let ID = KeychainWrapper.standard.string(forKey: "StudentID")
        let parameters: [String : Any] = [
                        "key": "99f5ca23983d05472617629cd9834816",
                        "image": "\(ImageUrl)",
                        "name": "\(ID)"
               ]
        return AF.request("https://api.imgbb.com/1/upload", method: .post, parameters: parameters)
    }
}
 

