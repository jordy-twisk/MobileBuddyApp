//
//  Root.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 03/01/2020.
//  Copyright © 2020 ProjectGroep5. All rights reserved.
//

import Foundation

struct Root : Decodable {

    private enum  CodingKeys: String, CodingKey {
        messages = [Messages] }
    
    let devices : [Messages]
}
