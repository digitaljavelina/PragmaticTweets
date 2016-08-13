//
//  KeyboardViewController.swift
//  PragmaticTweepsKeyboard
//
//  Created by Michael Henry on 4/14/16.
//  Copyright © 2016 Digital Javelina, LLC. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

class KeyboardViewController: UIInputViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweepNames: [String] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextKeyboardBarButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let twitterParams = ["count": "100"]
        guard let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json") else {
            return
        }
        
        sendTwitterRequest(twitterAPIURL, params: twitterParams) { (data, urlResponse, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.handleTwitterData(data, urlResponse: urlResponse, error: error)
            })
        }
    
        
    }

    @IBAction func nextKeyboardBarButtonTapped(sender: AnyObject) {
        advanceToNextInputMode()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweepNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as UITableViewCell!
        cell.textLabel?.text = "@\(tweepNames[indexPath.row])"
        return cell
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() received no data")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let jsonDict = jsonObject as? [String: AnyObject], usersArray = jsonDict ["users"] as? [[String: AnyObject]] else {
                NSLog("handleTwitterData() cannot parse data")
                return
            }
            tweepNames.removeAll()
            for userDict in usersArray {
                if let tweepName = userDict["screen_name"] as? String {
                    tweepNames.append(tweepName)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let atName = "@\(tweepNames[indexPath.row])"
        textDocumentProxy.insertText(atName)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
