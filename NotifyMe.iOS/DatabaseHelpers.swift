//
//  DatabaseHelpers.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 12/8/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

class Database {
    let webURL = URL(string: "https://box448.bluehost.com/~revoltap/notifyme/phpapi")!
    
    func createAccount(username: String, email: String, password: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let postData = ["email" : email,
                        "username" : username,
                        "password" : password]
        
        makePHPRequest(post: postData, onPage: "CreateUser.php") { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    func login(username: String, password: String, deviceID: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let postData = ["username" : username,
                        "password" : password,
                        "deviceID" : deviceID]
        
        makePHPRequest(post: postData, onPage: "Login.php") { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    func registerDevice(deviceID: String, userID: String, deviceName: String, defaultDevice: Bool, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let postData = ["source" : UIDevice.current.modelName,
                        "deviceID" : deviceID,
                        "deviceName" : deviceName,
                        "defaultDevice" : defaultDevice ? "0" : "1",
                        "userID" : userID]
        
        makePHPRequest(post: postData, onPage: "RegisterDevice.php") { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    @discardableResult
    func makePHPRequest(post: [String: String], onPage page: String, timeout: TimeInterval = 60, whenFinished: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> URLSessionDataTask {
        print("Function \(#function) and line number \(#line) in file \(#file)")
        
        let session = URLSession.shared
        var request = URLRequest(url: webURL.appendingPathComponent(page))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout
        
        var d = ""
        var sent = ""
        
        for key in post.keys {
            d = "\(d)\(sent)\(key)=\(post[key]!)"
            sent = "&"
        }
        
        request.httpBody = d.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request, completionHandler: whenFinished)
        
        task.resume()
        
        return task
    }
}
