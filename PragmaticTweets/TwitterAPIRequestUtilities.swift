//
//  TwitterAPIRequestUtilities.swift
//  PragmaticTweets
//
//  Created by Michael Henry on 4/4/16.
//  Copyright © 2016 Digital Javelina, LLC. All rights reserved.
//

import Foundation
import Social
import Accounts

public func sendTwitterRequest(requestURL: NSURL, params: [String: String], completion: SLRequestHandler) {
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) { (granted: Bool, error: NSError!) in
        guard granted else {
            NSLog("account access not granted")
            return
        }
        
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
        guard twitterAccounts.count > 0 else {
            NSLog("no twitter accounts configured")
            completion(nil, nil, NSError(domain: "PragmaticTweets", code: 1000, userInfo: [NSLocalizedDescriptionKey: "no Twitter accounts configured"]))
            return
        }
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: params)
        request.account = twitterAccounts.first as! ACAccount
        request.performRequestWithHandler(completion)
    }
}
