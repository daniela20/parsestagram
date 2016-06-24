//
//  PostViewController.swift
//  Parsestagram
//
//  Created by Daniela Gonzalez on 6/21/16.
//  Copyright © 2016 Daniela Gonzalez. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let size = CGSize(width: 375, height: 375)
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePost.image = resize(editedImage, newSize: size)
        } else {
            imagePost.image = resize(originalImage, newSize: size)
        }
        
        // Do something with the images (based on your use case)
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
        let libraryvc = UIImagePickerController()
        libraryvc.delegate = self
        libraryvc.allowsEditing = true
        libraryvc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(libraryvc, animated: true, completion: nil)
    }

    @IBAction func camera(sender: AnyObject) {
        let cameravc = UIImagePickerController()
        cameravc.delegate = self
        cameravc.allowsEditing = true
        cameravc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(cameravc, animated: true, completion: nil)
    }
    
    @IBAction func createPost(sender: AnyObject) {
        if imagePost.image != nil {
            Post.postUserImage(imagePost.image, withCaption: captionField.text, withCompletion: nil)
            imagePost.image = nil
            captionField.text = ""
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            self.performSegueWithIdentifier("logoutSegue3", sender: nil)
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
