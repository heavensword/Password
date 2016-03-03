//
//  PasswordItem.swift
//  Password
//
//  Created by Sword on 2/4/16.
//  Copyright © 2016 Sword. All rights reserved.
//

import UIKit

class PasswordItem: NSObject, NSCoding {
    var identifier:String?
    var name:String?
    var content:String?
    var checkPassword:Bool?
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(content, forKey: "content")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.identifier = aDecoder.decodeObjectForKey("identifier") as? String
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.content = aDecoder.decodeObjectForKey("content") as? String
    }
}