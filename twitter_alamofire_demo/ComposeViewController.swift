//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Marilyn Florek on 10/10/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate: class {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UIButton!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var user: User!
    var respondingToUser: User!
    
    weak var delegate: ComposeViewControllerDelegate?
    var tweetDelegate: replyCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10

        setUser()
    }
    
    func setUser(){
        if respondingToUser != nil {
            textView.textColor = UIColor.lightGray
            textView.text = "@\(respondingToUser.screenName ?? "") "
            textView.textColor = UIColor.black
        }
        
        if user != nil {
            userFullName.text = user.name
            userScreenName.text = "@\(user.screenName ?? "")"
            self.userImage.image = nil
            let url = NSURL(string: (user.imageURL)!)
            self.userImage.setImageWith(url! as URL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        let currentCount = newText.count
        characterCountLabel.setTitle(String(currentCount), for: .normal)
        
        if currentCount == characterLimit {
            characterCountLabel.setTitleColor(UIColor.red, for: .normal)
        } else {
            characterCountLabel.setTitleColor(UIColor.lightGray, for: .normal)
        }
        
        // The new text should be allowed? True/False
        return newText.count < characterLimit
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        let tweetText = textView.text
        APIManager.shared.composeTweet(with: tweetText!) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
    }

}
