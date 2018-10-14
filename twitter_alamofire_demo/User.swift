//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Marilyn Florek on 10/9/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var screenName: String?
    var imageURL: String?
    var backdropURL: String?
    var followerCount: Int?
    var tweetCount: Int?
    var followingCount: Int?
    
    static var _current: User?
    var dictionary: [String: Any]?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        imageURL = dictionary["profile_image_url_https"] as? String
        backdropURL = dictionary["profile_banner_url"] as? String
        followerCount = dictionary["followers_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    }
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
}
