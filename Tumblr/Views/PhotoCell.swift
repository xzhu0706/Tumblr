//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Xiaohong Zhu on 9/10/18.
//  Copyright © 2018 Xiaohong Zhu. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = .none
    }
    

}
