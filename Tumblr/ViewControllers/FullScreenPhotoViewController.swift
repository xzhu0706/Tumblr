//
//  FullScreenPhotoViewController.swift
//  Tumblr
//
//  Created by Xiaohong Zhu on 9/20/18.
//  Copyright © 2018 Xiaohong Zhu. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var photoURLString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height
        let photoWidth = frameWidth
        let photoHeight = photoWidth * 2 / 3
        let xPos = (frameWidth - photoWidth) / 2
        imageView.frame = CGRect(x: xPos, y: (frameHeight - photoHeight) / 2 - 30, width: photoWidth, height: photoHeight)
        
        closeButton.frame = CGRect(x: 15, y: 30, width: 20, height: 20)
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "closebutton"), for: UIControlState.normal)
        closeButton.contentHorizontalAlignment = .left
    
        scrollView.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        
        imageView.af_setImage(withURL: URL(string: photoURLString)!)
        scrollView.contentSize = imageView.image!.size
        
        view.bringSubview(toFront: closeButton)
    }
    
    @IBAction func didTapOnBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
