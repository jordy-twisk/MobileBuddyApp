//
//  Coach.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 01/05/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation

class Coach: Codable{
    var studentid: Int
    var workload: Int
    
    enum CodingKeys: String, CodingKey{
        case studentid = "studentID"
        case workload = "workload"
        
    }
}


