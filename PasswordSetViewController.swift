//
//  PasswordSetViewController.swift
//  Password
//
//  Created by Sword on 3/3/16.
//  Copyright © 2016 Sword. All rights reserved.
//

import UIKit

class PasswordSetViewController: UIViewController, YLSwipeLockViewDelegate {

    var lockView:YLSwipeLockView!
    var titleLabel:UILabel!
    var passwordString:String?
    var success:Bool = false
    
    let is_init_password_key = "#$%*sdjjdis_init_password_key"
    let password_key = "#$%*sdjjpassword_key"
    
    var initPassword:Bool {
        get {
            return !NSUserDefaults.standardUserDefaults().boolForKey(is_init_password_key)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(initPassword, forKey: is_init_password_key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    weak var delegate: PasswordSetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRectMake(40, 60, CGRectGetWidth(self.view.frame) - 80, 20)
        titleLabel = UILabel(frame: frame)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        if self.initPassword {
            titleLabel.text = "请设置使用密码"
        }
        else {
            titleLabel.text = "请输入密码"
            self.passwordString = NSUserDefaults.standardUserDefaults().objectForKey(password_key) as? String
        }
        self.view.addSubview(titleLabel)
        
        let viewWidth = CGRectGetWidth(self.view.frame) - 40
        let viewHeight = viewWidth
        let lockViewFrame = CGRectMake(20, CGRectGetHeight(self.view.bounds) - viewHeight - 40 - 100, viewWidth, viewHeight)
        lockView = YLSwipeLockView(frame: lockViewFrame)
        lockView.delegate = self;
        self.view.addSubview(lockView)
    }

    func dismiss() {
        self.delegate?.passwordSetViewControllerDidSet(self, success: success)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func storeGesturePassword() {
        self.initPassword = false
        NSUserDefaults.standardUserDefaults().setObject(self.passwordString, forKey: password_key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func swipeView(swipeView: YLSwipeLockView!, didEndSwipeWithPassword password: String!) -> YLSwipeLockViewState {
        if self.initPassword {
            if nil == self.passwordString  {
                titleLabel.text = "请确认您的手势密码"
                self.passwordString = password
                return .Normal;
            }
            else if (self.passwordString == password) {
                titleLabel.text = "设置成功"
                success = true
                storeGesturePassword()
                self.performSelector(Selector("dismiss"), withObject: nil, afterDelay: 1.0)
                return .Selected;
            }
            else {
                titleLabel.text = "两次输入的密码不一致"
                return .Warning;
            }
        }
        else {
            if (self.passwordString == password) {
                success = true
                self.performSelector(Selector("dismiss"), withObject: nil, afterDelay: 1.0)
                return .Selected;
            }
            else {
                titleLabel.text = "手势密码错误"
                return .Warning;
            }
        }
    }
}

protocol PasswordSetViewControllerDelegate : NSObjectProtocol {
    func passwordSetViewControllerDidSet(viewController: PasswordSetViewController, success: Bool) -> Void
}