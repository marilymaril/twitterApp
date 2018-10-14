//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Marilyn Florek on 10/9/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AFNetworking

protocol replyCellDelegate: class {
    func replyTweetCell(_ tweetCell: TweetCell, didTap user: User)
}

protocol TweetCellDelegate: class {
    func tweetCell(_ tweetCell: TweetCell, didTap user: User)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    @IBOutlet weak var favoritedBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var retweetedBy: UIButton!
    
    weak var delegate: TweetCellDelegate?
    weak var replyDelegate: replyCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            if tweet != nil {
                tweetTextLabel.text = tweet.text ?? "I love tweeting!!"
                userName.text = tweet.user?.name
                tweetTimestamp.text = "@\((tweet.user?.screenName)!)"
                self.userProfileImage.image = nil
                let url = NSURL(string: (tweet.user?.imageURL)!)
                self.userProfileImage.setImageWith(url! as URL)
                if tweet.retweetedByUser != nil {
                    let retweetUser = tweet.retweetedByUser?.screenName
                    retweetedBy.setTitle("\(retweetUser!) retweeted", for: .normal)
                    retweetedBy.isHidden = false
                } else {
                    retweetedBy.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapUserProfile(_:)))
        userProfileImage.addGestureRecognizer(profileTapGestureRecognizer)
        userProfileImage.isUserInteractionEnabled = true
        
        let replyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapReply(_:)))
        replyBtn.addGestureRecognizer(replyTapGestureRecognizer)
        replyBtn.isUserInteractionEnabled = true
        
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onRetweet(_:)))
        retweetBtn.addGestureRecognizer(retweetTapGestureRecognizer)
        retweetBtn.isUserInteractionEnabled = true
        
        let favoriteTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onFavorite(_:)))
        favoritedBtn.addGestureRecognizer(favoriteTapGestureRecognizer)
        favoritedBtn.isUserInteractionEnabled = true

    }
    
    func onRetweet(_ sender: Any) {
        self.retweetBtn.setImage(UIImage(named:"retweet-icon-green"), for: .normal)
        APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error retweeting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                var tweetCount = tweet.retweetCount! as Int
                tweetCount += 1
                tweet.retweetCount = tweetCount
                tweet.retweeted = true
                self.retweetBtn.imageView?.image = UIImage(named:"retweet-icon-red")
            }
        }
    }
    
    func onFavorite(_ sender: Any) {
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
    
    func didTapUserProfile(_ sender: UITapGestureRecognizer) {
        delegate?.tweetCell(self, didTap: tweet.user!)
    }
    
    func didTapReply(_ sender: UITapGestureRecognizer) {
        print("Tapped reply!")
        replyDelegate?.replyTweetCell(self, didTap: tweet.user!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
