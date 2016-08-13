//
//  SizeClassOverrideViewController.swift
//  PragmaticTweets
//
//  Created by Michael Henry on 4/8/16.
//  Copyright © 2016 Digital Javelina, LLC. All rights reserved.
//

import UIKit

var embeddedSplitVC: UISplitViewController!

class SizeClassOverrideViewController: UIViewController {
    
    var screenNameForOpenURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            embeddedSplitVC = segue.destinationViewController as! UISplitViewController
        } else if segue.identifier == "showUserFromURLSegue" {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = screenNameForOpenURL
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > 480.0 {
            let overrideTraits = UITraitCollection(horizontalSizeClass: .Regular)
            setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC!)
        } else {
            setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC!)
        }
    }
    
    @IBAction func unwindToSizeClassOverrideVC(segue: UIStoryboardSegue) {
        
    }


}
