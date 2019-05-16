//
//  RecordTableViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackView: UIView!
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackView.layer.masksToBounds = false
        waveView.layer.cornerRadius = waveView.frame.width / 2
        waveView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabel(data: (distance: Double, time: Int, date: Date, stamina: CGFloat)) {
        distanceLabel.text = String(format: "%.2f", data.distance) + " km"
        timeLabel.text = String(format: "0%d", Int(data.time / 60 / 60)) + ":" + Int(data.time / 60).string + ":" + Int(data.time % 60).string
        staminaLabel.text = String(format: "%.f", data.stamina * 100) + "%"
        dateLabel.text = data.date.string(withFormat: "yyyy.MM.dd HH:mm")
        
        let height = waveView.frame.height * data.stamina
        let wave = WaveView(frame: CGRect(x: 0,
                                          y: waveView.frame.height - height,
                                          width: waveView.frame.width + 10,
                                          height: height))
        if waveView.subviews.count == 0 {
            waveView.layoutSubviews()
            waveView.addSubview(wave)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        waveView.subviews.forEach { $0.removeFromSuperview() }
    }

}
