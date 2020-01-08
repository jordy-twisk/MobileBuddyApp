//
//  Tutorants.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 06/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation

class Tutorants: Codable{
    var tutorantid: Int
    var coachid: Int
    var status: String
    
    
    
    
    enum CodingKeys: String, CodingKey{
        case tutorantid = "studentIDTutorant"
        case coachid = "studentIDCoach"
        case status = "status"
        
        
    }
}

