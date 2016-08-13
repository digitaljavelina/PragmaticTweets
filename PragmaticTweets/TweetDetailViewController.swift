//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Michael Henry on 4/5/16.
//  Copyright © 2016 Digital Javelina, LLC. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    
    var tweetIdString: String? {
        didSet {
            reloadTweetDetails()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func reloadTweetDetails() {
        guard let tweetIdString = tweetIdString else {
            return
        }
        if let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json") {
            let twitterParams = ["id": tweetIdString]
            sendTwitterRequest(twitterAPIURL, params: twitterParams, completion: { (data, urlResponse, error) in
                dispatch_async(dispatch_get_main_queue(), { 
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
            })
        }
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() received no data")
            return
        }
        
        NSLog("handleTwittweData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let tweetDict = jsonObject as? [String: AnyObject] else {
                NSLog("handleTwitterData() did not get a dictionary")
                return
            }
            NSLog("tweetDict: \(tweetDict)")
            self.tweetTextLabel.text = tweetDict["text"] as? String
            if let userDict = tweetDict["user"] as? [String: AnyObject] {
                self.userRealNameLabel.text = (userDict["name"] as! String)
                self.userScreenNameLabel.text = "@" + (userDict["screen_name"] as! String)
                self.userImageButton.setTitle(nil, forState: .Normal)
                if let userImageURL = NSURL(string: userDict["profile_image_url_https"] as! String), userImageData = NSData(contentsOfURL: userImageURL) {
                    self.userImageButton.setImage(UIImage(data: userImageData), forState: .Normal)
                }
                if let entities = tweetDict["entities"] as? [String: AnyObject], media = entities["media"] as? [[String: AnyObject]], mediaString = media[0]["media_url_https"] as? String, mediaURL = NSURL(string: mediaString), mediaData = NSData(contentsOfURL: mediaURL) {
                    tweetImageView.image = UIImage(data: mediaData)
                } else {
                    tweetImageView.image = nil
                }
            }
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTweetDetails()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userDetailVC = segue.destinationViewController as? UserDetailViewController where segue.identifier == "showUserDetailSegue" {
            userDetailVC.screenName = userScreenNameLabel.text
        }
    }
    
    @IBAction func unwindToTweetDetailVC(segue: UIStoryboardSegue) {
        
    }

}
