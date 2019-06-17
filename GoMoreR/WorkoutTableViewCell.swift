//
//  WorkoutTableViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
