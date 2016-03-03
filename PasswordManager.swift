//
//  PasswordManager.swift
//  Password
//
//  Created by Sword on 2/4/16.
//  Copyright © 2016 Sword. All rights reserved.
//

import UIKit

class PasswordManager: NSObject {
    let passwords_key = "passwords_keys"
    
    var passwords:[PasswordItem]?
    var passwordKeys:[String]?
    
    static let sharedInstance = PasswordManager()
    
    private override init() {
        super.init()
        passwordKeys = [String]()
        let storeKeys:[String]? = NSUserDefaults.standardUserDefaults().objectForKey(passwords_key) as! [String]?
        if let _ = storeKeys {
            for value in storeKeys! {
                passwordKeys!.append(value)
            }
        }
        passwords = [PasswordItem]()
        for key in passwordKeys! {
            let value = passwordItemWithIdentifier(key)
            if let _ = value {
                passwords?.append(value!)
            }
        }
        
        registerObservers()
    }
    
    func registerObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("save"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("save"), name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    func count() -> Int {
        return passwords!.count
    }
    
    func savePasswordItem(item:PasswordItem) {
        let passwordData = NSKeyedArchiver.archivedDataWithRootObject(item)
        NSUserDefaults.standardUserDefaults().setObject(passwordData, forKey: item.identifier!)
    }
    
    func save() {
        NSUserDefaults.standardUserDefaults().setObject(passwordKeys, forKey: passwords_key)
        for passwordItem in passwords! {
            savePasswordItem(passwordItem)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func addPasswordItem(item:PasswordItem) {
        
        passwordKeys?.append(item.identifier!)
        passwords?.append(item)

        NSUserDefaults.standardUserDefaults().setObject(passwordKeys, forKey: passwords_key)
        savePasswordItem(item)
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func removePasswordKey(key:String!) {
        for (index, passwordKey) in passwordKeys!.enumerate() {
            if passwordKey == key {
                passwordKeys?.removeAtIndex(index)
                break;
            }
        }
    }
    
    func removePasswordItem(item:PasswordItem!) -> Bool {
        if let _ = item {
            removePasswordKey(item.identifier!)
            var removed = false
            for (index, value) in passwords!.enumerate() {
                if value.identifier == item.identifier {
                    passwords?.removeAtIndex(index)
                    removed = true
                    break;
                }
            }
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.removeObjectForKey(item.identifier!)
            userDefault.synchronize()
            
            return removed
        }
        return false
    }
    
    func passwordItemAtIndex(index: Int) -> PasswordItem? {
        if index >= 0 && index < passwords!.count {
            return passwords![index]
        }
        else {
            return nil
        }
    }

    func passwordItemWithIdentifier(identifier: String) -> PasswordItem? {
        if passwordKeys!.contains(identifier) {
            let userDefault = NSUserDefaults.standardUserDefaults()
            let passwordItemData = userDefault.objectForKey(identifier) as! NSData?
            if let _ = passwordItemData {
                let passwordItem = NSKeyedUnarchiver.unarchiveObjectWithData(passwordItemData!) as! PasswordItem?
                return passwordItem
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func updatePasswordItem(item:PasswordItem!) {
        if let _ = item {
            if passwords!.contains(item) {
            }
            else {
                for (index, value) in passwords!.enumerate() {
                    if value.identifier == item.identifier {
                        passwords?.removeAtIndex(index)
                        passwords?.insert(item, atIndex: index)
                        break;
                    }
                }
            }
            savePasswordItem(item)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
