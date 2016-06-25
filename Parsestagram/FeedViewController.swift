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
        return 1
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
        let post = posts[indexPath.section]
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
        
        feedView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HeaderCell")
        feedView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        let profileImage = UIImage(named:"profile-placeholder")!
        profileView.image = profileImage
        headerView.addSubview(profileView)
        
        let userLabel = UILabel(frame: CGRectMake(50, 0, 320, 50))
        userLabel.font = UIFont.boldSystemFontOfSize(17.0)
        let post = posts[section]
        if let user = post["author"] as? PFUser {
            userLabel.text = user.username
        }
        headerView.addSubview(userLabel)
        
        let timeLabel = UILabel(frame: CGRectMake(230, 0, 130, 50))
        timeLabel.font = UIFont.systemFontOfSize(14.0)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        let dateString = dateFormatter.stringFromDate(post.createdAt!)
        timeLabel.text = dateString
        timeLabel.textAlignment = NSTextAlignment.Right
        headerView.addSubview(timeLabel)

        return headerView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}
