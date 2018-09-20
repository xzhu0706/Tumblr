//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Xiaohong Zhu on 9/10/18.
//  Copyright © 2018 Xiaohong Zhu. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var posts: [[String: Any]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchPosts()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        // Show progress HUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        fetchPosts()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PhotoCell
        let photoWidth = cell.frame.width * 0.9
        let photoHeight = photoWidth * 2 / 3
        let xPos = (cell.frame.width - photoWidth) / 2
        let yPos = (cell.frame.height - photoHeight) / 2 - 10
        cell.photoImageView.frame = CGRect(x: xPos, y: yPos, width: photoWidth, height: photoHeight)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        // Set the avater
        let profileView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Set the date
        let label = UILabel(frame: CGRect(x: 50, y: 5, width: view.frame.width - 50, height: 30))
        label.font = UIFont.systemFont(ofSize: 16)
        let post = posts[section]
        if let date = post["date"] as? String {
            label.text = date
        }
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.section]
        
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            
            // Get large image url
            let originalSize = photo["original_size"] as! [String: Any]
            let originalURLString = originalSize["url"] as! String
            let originalURL = URL(string: originalURLString)!
            
            // Get small image url
            let altSizes = photo["alt_sizes"] as! [[String: Any]]
            let smallSize = altSizes[6]
            let smallSizeURLString = smallSize["url"] as! String
            let smallSizeURL = URL(string: smallSizeURLString)!
            
            // Set placeholder image
            let placeholderImage = UIImage(named: "placeholder")
            
            // Set filter
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: cell.photoImageView.frame.size, radius: 30.0)
            
            // Set image view
            cell.photoImageView.af_setImage(withURL: smallSizeURL, placeholderImage: placeholderImage, filter: filter,  imageTransition: .curlDown(0.2), runImageTransitionIfCached: false) { (response) in
                cell.photoImageView.af_setImage(withURL: originalURL, filter: filter,  imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false)
            }
            
            // Set cell selection style
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red:0.92, green:0.98, blue:0.98, alpha:1.0)
            cell.selectedBackgroundView = backgroundView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! PhotoCell
        
        // Deselect the cell when tap on a selected cell
        if cell.isSelected {
            tableView.deselectRow(at: indexPath, animated: true)
            return nil
        } else {
            return indexPath
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoCell
        if let indexPath = tableView.indexPath(for: cell) {
            let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
            let post = self.posts[indexPath.section]
            let photos = post["photos"] as! [[String: Any]]
            photoDetailsViewController.photos = photos
        }
    }
    
    func fetchPosts() {
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                
                // Display error alert if fail to load
                let alertController = UIAlertController(title: "Error", message: "Network is not available, please check Settings.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // Get the posts and store in posts property
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // Reload the table view
                self.tableView.reloadData()
            }
        }
        PKHUD.sharedHUD.hide()
        self.refreshControl.endRefreshing()
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
