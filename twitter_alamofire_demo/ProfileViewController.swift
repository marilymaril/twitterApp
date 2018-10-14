//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Marilyn Florek on 10/10/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, replyCellDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBackdrop: UIImageView!
    @IBOutlet weak var profileFullName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage2: UIImageView!
    var user: User!
    var tweetUser: User!
    
    var delegate: TweetCellDelegate?
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 20

        if tweetUser != nil {
            self.user = tweetUser
        } else {
            self.user = User.current
        }
        
        setData()
        getTimeline()
    }
    
    func setData() {
        if user != nil {
            profileFullName.text = user.name
            profileUsername.text = "@\((user.screenName)!)"
            self.profileImage.image = nil
            self.profileBackdrop.image = nil
            let url = NSURL(string: (user.imageURL)!)
            self.profileImage.setImageWith(url! as URL)
            if user.backdropURL != nil {
                print(user.backdropURL!)
                let backdropurl = NSURL(string: (user.backdropURL)!)
                self.profileBackdrop.setImageWith(backdropurl! as URL)
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.profileBackdrop.addSubview(blurEffectView)
            }
            self.followerCount.text = String(user.followerCount!)
            self.followingCount.text = String(user.followingCount!)
            self.tweetCount.text = String(user.tweetCount!)
        }
    }
    
    func getTimeline() {
        APIManager.shared.getUserTimeLine(user, completion: { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tableView.isHidden = false
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.getTimeline()
                }
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {}
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! TweetCell

        cell.delegate = self
        cell.replyDelegate = self
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func tweetCell(_ tweetCell: TweetCell, didTap user: User) {
        print("Clicked profile")
        performSegue(withIdentifier: "tweetProfileSegue", sender: user)
    }
    
    func replyTweetCell(_ tweetCell: TweetCell, didTap user: User) {
        print("IN TIMELINE")
        performSegue(withIdentifier: "replySegue", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tweetDetailSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailViewController = segue.destination as! TweetDetailViewController
            
            let tweet = self.tweets[indexPath!.row]
            detailViewController.tweet = tweet
        }
        
        if segue.identifier == "replySegue" {
            if let detailViewController = segue.destination as? ComposeViewController {
                detailViewController.tweetDelegate = self
                detailViewController.user = User.current
                detailViewController.respondingToUser = sender as! User
            }
        }
        
        if segue.identifier == "tweetProfileSegue" {
            if let detailViewController = segue.destination as? ProfileViewController {
                detailViewController.delegate = self
                detailViewController.tweetUser = sender as! User
            }
        }
    }

}
