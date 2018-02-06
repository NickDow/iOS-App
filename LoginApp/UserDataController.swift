//
//  UserDataController.swift
//  LoginApp
//
//  Created by miyu enterprise on 12/1/17.
//  Copyright © 2017 miyu enterprise. All rights reserved.
//

import UIKit

class UserDataController: UIViewController {

    var myUN: String!
    var myPW: String!
    var myCurrExp: Int!
    var myNeedExp: Int!
    
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var current_exp: UILabel!
    @IBOutlet weak var needed_exp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        username.text = myUN
        password.text = myPW
        current_exp.text = String(myCurrExp)
        needed_exp.text = String(myNeedExp)
        // Do any additional setup after loading the view.
    }
}
