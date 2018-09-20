//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Xiaohong Zhu on 9/19/18.
//  Copyright © 2018 Xiaohong Zhu. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photos: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frameWidth = view.frame.width
        let photoWidth = frameWidth * 0.95
        let photoHeight = photoWidth * 2 / 3
        let xPos = (frameWidth - photoWidth) / 2
        let yPos = (self.navigationController?.navigationBar.frame.size.height)! + 30.0
        photoImageView.frame = CGRect(x: xPos, y: yPos, width: photoWidth, height: photoHeight)
        
        let photo = self.photos[0]
        let orignalPhoto = photo["original_size"] as! [String: Any]
        let orignalPhotoURLString = orignalPhoto["url"] as! String
        let orginalURL = URL(string: orignalPhotoURLString)!
        photoImageView.af_setImage(withURL: orginalURL)
    }
    
    @IBAction func didTapOnPhoto(_ sender: Any) {
        performSegue(withIdentifier: "ToFullScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fullScreenPhotoViewController = segue.destination as! FullScreenPhotoViewController
        let photo = self.photos[0]
        let orignalPhoto = photo["original_size"] as! [String: Any]
        let orignalPhotoURLString = orignalPhoto["url"] as! String
        fullScreenPhotoViewController.photoURLString = orignalPhotoURLString
    }
}
