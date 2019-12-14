//
//  Messages.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 05/12/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import Foundation

class Messages: Codable{
        var messageid: Int
        var type: String
        var payload: String
        var created: String
        var lastmodified: String
        var senderid: Int
        var receiverid: Int
        
        
        enum CodingKeys: String, CodingKey{
            case messageid = "MessageID"
            case type = "type"
            case payload = "payload"
            case created = "created"
            case lastmodified = "lastModified"
            case senderid = "senderID"
            case receiverid = "receiverID"
            
        }
    }
