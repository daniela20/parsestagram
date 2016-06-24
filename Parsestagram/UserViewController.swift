//
//  FeedViewController.swift
//  Parsestagram
//
//  Created by Daniela Gonzalez on 6/22/16.
//  Copyright © 2016 Daniela Gonzalez. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var userFeedView: UITableView!
    
    var posts : [PFObject]!
    var isMoreDataLoading = false
    var limit : Int = 20
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = userFeedView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - userFeedView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && userFeedView.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        print("loading more data")
        queryPosts()
        limit += 10
        self.isMoreDataLoading = false
        self.userFeedView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = userFeedView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.captionLabel.text = post["caption"] as? String
        let imageFile = post["media"] as! PFFile
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.imagePost.image = UIImage(data:imageData)
                }
            }
            
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userFeedView.dataSource = self
        userFeedView.delegate = self
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(FeedViewController.onTimer), userInfo: nil, repeats: true)
        self.queryPosts()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        userFeedView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        queryPosts()
        self.userFeedView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onTimer() {
        self.queryPosts()
    }
    
    func queryPosts() {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        if let cur = PFUser.currentUser() {
            query.whereKey("author", equalTo: cur)
        }
        
        query.addDescendingOrder("createdAt")
        query.limit = limit
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully got posts")
                
                if let objects = objects {
                    self.posts = objects
                    self.userFeedView.reloadData()
                }
            } else {
                print("Error")
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
                self.performSegueWithIdentifier("logoutSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailSegue2"){
            let cell = sender as! UITableViewCell
            let indexPath = userFeedView.indexPathForCell(cell)
            let post = posts[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.post = post
        }
    }
    
}
