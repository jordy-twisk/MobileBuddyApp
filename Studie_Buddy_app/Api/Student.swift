//
//  Student.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 10/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation

class Student: Codable{
    var studentid: Int
    var firstname: String
    var surname: String
    var phonenumber: String
    var photo: String
    var description: String
    var degree: String
    var study: String
    var studyyear: Int
    var interests: String
    
    
    
    enum CodingKeys: String, CodingKey{
        case studentid = "studentID"
        case firstname = "firstName"
        case surname = "surName"
        case phonenumber = "phoneNumber"
        case photo = "photo"
        case description = "description"
        case degree = "degree"
        case study = "study"
        case studyyear = "studyYear"
        case interests = "interests"
        
    }
}

