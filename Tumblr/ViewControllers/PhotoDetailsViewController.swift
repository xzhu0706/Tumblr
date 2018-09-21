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
    var trails: [[String: Any]] = []
    var contentTextView: UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height
        let photoWidth = frameWidth * 0.95
        let photoHeight = photoWidth * 2 / 3
        let xPos = (frameWidth - photoWidth) / 2
        let yPos = (self.navigationController?.navigationBar.frame.size.height)! + 30.0
        
        photoImageView.frame = CGRect(x: xPos, y: yPos, width: photoWidth, height: photoHeight)
        contentTextView.frame = CGRect(x: xPos, y: yPos + photoHeight + 10, width: photoWidth, height: frameHeight - photoWidth - 10)
        contentTextView.textColor = UIColor.black
        contentTextView.backgroundColor = UIColor.clear
        contentTextView.isEditable = false
        
        let photo = self.photos[0]
        let orignalPhoto = photo["original_size"] as! [String: Any]
        let orignalPhotoURLString = orignalPhoto["url"] as! String
        let orginalURL = URL(string: orignalPhotoURLString)!
        photoImageView.af_setImage(withURL: orginalURL)
        
        let trail = self.trails[0]
        if let content = trail["content"] as? String {
            if let contentString: NSMutableAttributedString = decodeString(encodedString: content) {
                contentString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.thin), range: NSRange(location: 0, length: contentString.length))
                contentTextView.attributedText = contentString
            }
        }
        
        view.addSubview(contentTextView)
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
    
    func decodeString(encodedString: String) -> NSMutableAttributedString? {
        // Convert html elements to NSAttributedString
        let encodedData = encodedString.data(using: String.Encoding.utf8)!
        do {
            return try NSMutableAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}
