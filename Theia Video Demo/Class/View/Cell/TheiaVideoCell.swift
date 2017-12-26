//
//  TheiaVideoCell.swift
//  Theia Video Demo
//
//  Created by Tuan Shou Cheng on 2017/12/20.
//  Copyright © 2017年 Tuan Shou Cheng. All rights reserved.
//

import UIKit

class TheiaVideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var labelView: UIView! {
        didSet {
            labelView.layer.cornerRadius = 3
            labelView.layer.masksToBounds = true
        }
    }
    
    static let identifier = "theia video cell"
    
    let dateComponentFormatter = DateComponentsFormatter()
    
    func setupVideoTime(_ seconds: TimeInterval) {
        durationLabel.text = dateComponentFormatter.string(from: seconds)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.separatorInset = .zero
        
        dateComponentFormatter.allowedUnits = [.minute, .second]
        dateComponentFormatter.unitsStyle = .positional
        dateComponentFormatter.zeroFormattingBehavior = .pad
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = headerImageView.bounds.size.width
        headerImageView.layer.cornerRadius = width / 2.0
        headerImageView.layer.masksToBounds = true
    }
    
}
