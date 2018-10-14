//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, TweetCellDelegate, replyCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 20
        activityIndicator.startAnimating()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        getData()

    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        activityIndicator.startAnimating()
        getData()
        refreshControl.endRefreshing()
    }
    
    func getData() {
        APIManager.shared.getHomeTimeLine { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.getData()
                }
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {}
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.delegate = self
        cell.replyDelegate = self
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets.count > 0 {
            return tweets.count
        } else {
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetailSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailViewController = segue.destination as! TweetDetailViewController
            
            let tweet = self.tweets[indexPath!.row]
            detailViewController.tweet = tweet
        }
        
        if segue.identifier == "composeSegue" {
            let detailViewController = segue.destination as! ComposeViewController
            
            detailViewController.user = User.current
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func did(post: Tweet) {
        getData()
    }
    
    func tweetCell(_ tweetCell: TweetCell, didTap user: User) {
        print("Clicked profile")
        performSegue(withIdentifier: "tweetProfileSegue", sender: user)
    }
    
    func replyTweetCell(_ tweetCell: TweetCell, didTap user: User) {
        print("IN TIMELINE")
        performSegue(withIdentifier: "replySegue", sender: user)
    }
}
