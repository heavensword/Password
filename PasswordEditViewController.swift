//
//  PasswordEditViewController.swift
//  Password
//
//  Created by Sword on 2/4/16.
//  Copyright © 2016 Sword. All rights reserved.
//

import UIKit

class PasswordEditViewController: UIViewController {

    var passwordItem:PasswordItem!
    
    @IBOutlet weak var passwordTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        passwordTextView.text = passwordItem.content
        passwordTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupItems() {
        self.title = passwordItem.name
        let addItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("updatePassword"))
        self.navigationItem.rightBarButtonItem = addItem
    }

    func updatePassword () {
        self.passwordItem.content = passwordTextView.text
        PasswordManager.sharedInstance.updatePasswordItem(passwordItem)
        self.navigationController?.view.makeToast("保存成功", duration: 0.5, position: "center")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
