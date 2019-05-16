//
//  MainCollectionViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/13.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var staminaLabel: UILabel!
    
    @IBOutlet weak var waveView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLabel(data: (distance: Double, time: Int, level: CGFloat, stamina: CGFloat)) {
        distanceLabel.text = String(format: "%.2f", data.distance) + " km"
        timesLabel.text = Int(data.time / 60).string + "h " + Int(data.time % 60).string + "m"
        staminaLabel.text = String(format: "%.f", data.stamina * 100) + "%"
        levelLabel.text = String(format: "%.2f", data.level)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        waveView.subviews.forEach { $0.removeFromSuperview() }
    }
    
}
