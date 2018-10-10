//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Marilyn Florek on 10/9/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    @IBOutlet weak var favoritedBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var replyBtn: UIButton!
    
    var tweet: Tweet! {
        didSet {
            if tweet != nil {
                tweetTextLabel.text = tweet.text ?? "I love tweeting!!"
                userName.text = tweet.user?.screenName
                tweetTimestamp.text = tweet.createdAtString
                if let url = tweet.user?.imageURL {
                    userProfileImage.af_setImage(withURL: url)
                } else {
                    userProfileImage.image = UIImage(named:"profile-icon")
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onReply(_ sender: Any) {
        print("Replied!")
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        retweetBtn.imageView?.image = UIImage(named:"retweet-icon-green")
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(String(describing: tweet.text))")
                var tweetCount = tweet.favoriteCount as Int
                tweetCount += 1
                tweet.favoriteCount = tweetCount
                tweet.favorited = true
                self.favoritedBtn.imageView?.image = UIImage(named:"favor-icon-red")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
