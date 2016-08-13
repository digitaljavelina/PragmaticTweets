//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Michael Henry on 4/1/16.
//  Copyright © 2016 Digital Javelina, LLC. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    
    @IBOutlet weak var twitterWebView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("I just finished the first project in iOS 9 SDK Development, #pragsios9")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            NSLog("Can't send tweet")
        }
    }

    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        if let url = NSURL(string: "https://twitter.com/tweetcompost") {
            let urlRequest = NSURLRequest(URL: url)
            twitterWebView.loadRequest(urlRequest)
        }
    }
}

