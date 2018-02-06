//
//  ViewController.swift
//  LoginApp
//
//  Created by miyu enterprise on 11/30/17.
//  Copyright © 2017 miyu enterprise. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    var returned_email: String!
    var returned_pass: String!
    var current_exp: Int!
    var needed_exp: Int!
    var loading : UIView?
    
    @IBAction func getUserDataBtn(_ sender: Any) {
        if emailAddress.text != "" && userPassword.text != ""
        {
            let parameters = ["nameValuePairs":["username": emailAddress.text, "password": userPassword.text]]
            guard let myURL = URL(string: "https://51cde512.ngrok.io/getUser") else {return}
            var request = URLRequest(url: myURL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 300.0)
            
            request.httpMethod = "POST"
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let myData = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: myData, options: .allowFragments) as! [String:Any]
                        if let email_prop = (json["username"] as? String){
                            DispatchQueue.main.async {
                                self.returned_email = json["username"] as! String
                                self.returned_pass = json["password"] as! String
                                self.current_exp = json["curr_exp"] as! Int
                                self.needed_exp = json["needed_exp"] as! Int
                                self.performSegue(withIdentifier: "GetUserDataSegue", sender: self)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "InvalidCredsSegue", sender: self)
                            }
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func addMoneyBtn(_ sender: Any) {
        if emailAddress.text != "" && userPassword.text != ""{
            loading = UIView(frame: view.frame)
            loading!.backgroundColor = UIColor.black
            loading!.alpha = 0.8
            view.addSubview(loading!)
            let session = URLSession.shared
            let parameters = ["nameValuePairs":["username": emailAddress.text, "password": userPassword.text]]
            guard let myURL = URL(string: "https://51cde512.ngrok.io/login") else {return}
            var request = URLRequest(url: myURL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 3000.0)
            
            request.httpMethod = "POST"
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let myData = data{
                    do{
                        guard let httpReponse = response as? HTTPURLResponse else {return}
                        if(httpReponse.statusCode != 200){
                            if(httpReponse.statusCode == 400){
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "foHundoError", sender: self)
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "InvalidCredsSegue", sender: self)
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.loading?.removeFromSuperview()
                                self.performSegue(withIdentifier: "AddMoneySegue", sender: self)
                            }
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }).resume()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GetUserDataSegue"){
            guard let viewController = segue.destination as? UserDataController else{return}
            viewController.myUN = returned_email
            viewController.myPW = returned_pass
            viewController.myCurrExp = current_exp
            viewController.myNeedExp = needed_exp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

