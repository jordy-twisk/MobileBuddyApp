//
//  Coaches.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 01/05/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation

class Coaches: Codable{
    var coach: Coach
    var student: Student

    enum CodingKeys: String, CodingKey{
        case coach = "coach"
        case student = "student"
        
    }
}


