//
//  FeedViewController.swift
//  Parsestagram
//
//  Created by Daniela Gonzalez on 6/22/16.
//  Copyright © 2016 Daniela Gonzalez. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var feedView: UITableView!
    
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
            let scrollViewContentHeight = feedView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - feedView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && feedView.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        queryPosts()
        limit += 10
        self.isMoreDataLoading = false
        self.feedView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = feedView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
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
        feedView.dataSource = self
        feedView.delegate = self
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(FeedViewController.onTimer), userInfo: nil, repeats: true)
        self.queryPosts()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        feedView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        queryPosts()
        self.feedView.reloadData()
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
        //query.includeKey("time")
        query.addDescendingOrder("createdAt")
        query.limit = limit
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.posts = objects
                    self.feedView.reloadData()
                }
            }
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = feedView.indexPathForCell(cell)
            let post = posts[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.post = post
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            self.performSegueWithIdentifier("logoutSegue2", sender: nil)
        }
    }

}
