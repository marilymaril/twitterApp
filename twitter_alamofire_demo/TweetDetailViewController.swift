//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Marilyn Florek on 10/10/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userUserName: UILabel!
    @IBOutlet weak var userTweet: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetRetweetCount: UILabel!
    @IBOutlet weak var tweetFavoriteCount: UILabel!
    
    var tweetUser: User!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTweet()
    }
    
    func setTweet() {
        if tweet != nil {
            userTweet.text = tweet.text ?? "I love tweeting!!"
            userFullName.text = tweet.user?.name
            userUserName.text = "@\(tweet.user?.screenName ?? "")"
            tweetFavoriteCount.text = String(tweet.favoriteCount)
            tweetRetweetCount.text = String(tweet.retweetCount!)
            tweetDate.text = tweet.createdAtString
            self.userImage.image = nil
            let url = NSURL(string: (tweet.user?.imageURL)!)
            self.userImage.setImageWith(url! as URL)
            tweetUser = tweet.user
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: Any) {
    }
    
    @IBAction func onFavorite(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replySegue" {
            let detailViewController = segue.destination as! ComposeViewController
            
            detailViewController.user = User.current
            
            detailViewController.respondingToUser = self.tweetUser
        }
    }
    
    

}
