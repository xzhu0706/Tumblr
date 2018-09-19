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
        let photoWidth = frameWidth
        let photoHeight = photoWidth * 3 / 4
        let xPos = (frameWidth - photoWidth) / 2
        photoImageView.frame = CGRect(x: xPos, y: 0, width: photoWidth, height: photoHeight)
        
        let photo = self.photos[0]
        let orignalPhoto = photo["original_size"] as! [String: Any]
        let orignalPhotoURLString = orignalPhoto["url"] as! String
        print(orignalPhotoURLString)
        let orginalURL = URL(string: orignalPhotoURLString)!
        photoImageView.af_setImage(withURL: orginalURL)
        
    }
    
    
}
