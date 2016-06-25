//
//  DetailViewController.swift
//  Parsestagram
//
//  Created by Daniela Gonzalez on 6/23/16.
//  Copyright © 2016 Daniela Gonzalez. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {
    
    var post : PFObject!
    @IBOutlet var detailView: UIView!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.captionLabel.text = post["caption"] as? String
        let imageFile = post["media"] as! PFFile
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.photo.image = UIImage(data:imageData)
                }
            }
        }
        
        /*let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        let dateString = dateFormatter.stringFromDate(post.createdAt!)
        timeStampLabel.text = dateString*/
       
        /*if let user = post["author"] as? PFUser {
            self.usernameLabel.text = user.username
        }*/
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 74, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        let profileImage = UIImage(named:"profile-placeholder")!
        profileView.image = profileImage
        detailView.addSubview(profileView)
        
        let userLabel = UILabel(frame: CGRectMake(50, 64, 320, 50))
        userLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //let post = posts[section]
        if let user = post["author"] as? PFUser {
            userLabel.text = user.username
        }
        detailView.addSubview(userLabel)
        
        let timeLabel = UILabel(frame: CGRectMake(230, 64, 130, 50))
        timeLabel.font = UIFont.systemFontOfSize(14.0)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        let dateString = dateFormatter.stringFromDate(post.createdAt!)
        timeLabel.text = dateString
        timeLabel.textAlignment = NSTextAlignment.Right
        detailView.addSubview(timeLabel)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
