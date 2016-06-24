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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        let dateString = dateFormatter.stringFromDate(post.createdAt!)
        timeStampLabel.text = dateString
       
        if let user = post["author"] as? PFUser {
            self.usernameLabel.text = user.username
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            self.performSegueWithIdentifier("logoutSegue4", sender: nil)
            self.performSegueWithIdentifier("logoutSegue5", sender: nil)
        }
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
