//
//  NewsCollectionViewCell.swift
//  MM2
//
//  Created by user147645 on 4/5/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellHeadline: UILabel!
    @IBOutlet weak var cellURL: UILabel!
    @IBOutlet weak var cellDateSourceRelated: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellSummary: UITextView!
    
    
    @IBOutlet weak var newsImageOutlet: UIImageView!
    @IBOutlet weak var textFieldOutlet: UITextView!
    
    
    
    var data = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        
        
        
        
        
    }
}
