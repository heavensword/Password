//
//  ViewController.swift
//  Password
//
//  Created by Sword on 2/4/16.
//  Copyright © 2016 Sword. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UITableViewController, PasswordSetViewControllerDelegate {
    
    var selectedIndexPath:NSIndexPath?
    var passwordManager:PasswordManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "密码助手"
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        setupItems()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        authorizeUserByTouchId()        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationDidBecomeActive() {
        NSLog("applicationDidBecomeActive")
        authorizeUserByTouchId()
    }
    
    func authorizeUserByTouchId() {
        let context = LAContext()
        var error:NSError?
        let reasonString = "我们需要使用您的TouchID进行授权"
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((0.3 * Double(NSEC_PER_SEC)))), dispatch_get_main_queue(), {
                        self.loadData()
                    })
                }
                else {
                    if let _ = self.passwordManager {
                        self.passwordManager = nil;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((0.3 * Double(NSEC_PER_SEC)))), dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                    let alert = UIAlertController(title: "", message: "请允许使用TouchId，否则无法使用App", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Default, handler: {(alertAction:UIAlertAction) in
                        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                    })
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })]
        }
        else {
            let passwordSetViewController = PasswordSetViewController ()
            passwordSetViewController.delegate = self
            self.presentViewController(passwordSetViewController, animated: true, completion: nil)
        }
    }
    
    func setupItems() {
        NSLog("%@", self.navigationItem)
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addItem"))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    func loadData() {
        if nil == self.passwordManager {
            self.passwordManager = PasswordManager.sharedInstance
            var indexPaths = [NSIndexPath]()
            for index in 0..<self.passwordManager!.count() {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                indexPaths.append(indexPath)
            }
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
        }
    }
    
    func addItem () {
        let alert = UIAlertController(title: "", message: "请填写密码名字", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {(alertAction:UIAlertAction) in
        })
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {(alertAction:UIAlertAction) in
            let item = PasswordItem()
            let uuidString = NSUUID().UUIDString
            NSLog("uuidString %@", uuidString)
            let passwordName = alert.textFields?.first?.text
            if passwordName?.characters.count > 0 {
                item.name = passwordName
            }
            else {
                item.name = "密码\(self.passwordManager!.count())"
            }
            item.identifier = uuidString
            self.passwordManager?.addPasswordItem(item)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
        alert.addTextFieldWithConfigurationHandler({(textField:UITextField) in })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = passwordManager {
            return self.passwordManager!.count()
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PasswordCell", forIndexPath: indexPath) as! PasswordCell
        cell.passwordItem = passwordManager!.passwordItemAtIndex(indexPath.row)
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndexPath = indexPath
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        selectedIndexPath = indexPath
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if .Delete == editingStyle {
            let passwordItem = passwordManager!.passwordItemAtIndex(indexPath.row)
            if passwordItem != nil {
                passwordManager!.removePasswordItem(passwordItem!)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == edit_password_segue {
            let viewController = segue.destinationViewController as! PasswordEditViewController
            viewController.passwordItem = passwordManager!.passwordItemAtIndex(selectedIndexPath!.row)
        }
    }
    
    func passwordSetViewControllerDidSet(viewController: PasswordSetViewController, success: Bool) {
        if success {
            self.loadData()
        }
        else {
            self.passwordManager = nil
            self.tableView.reloadData()
        }
    }
}

