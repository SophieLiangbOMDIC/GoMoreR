//
//  RecordTableViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutIdLabel: UILabel!
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
    
    func setLabel(distance: Double, time: Int, date: Date, stamina: CGFloat, workoutId: String) {
        distanceLabel.text = String(format: "%.2f", distance) + " km"
        timeLabel.text = secondsToString(time)
        staminaLabel.text = String(format: "%.f", stamina * 100) + "%"
        dateLabel.text = date.string(withFormat: "yyyy.MM.dd HH:mm")
        workoutIdLabel.text = workoutId
        
        let height = waveView.frame.height * stamina
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

func secondsToString(_ seconds : Int) -> String {
    
    let hours = Int(seconds / 3600)
    let minutes = Int(seconds % 3600 / 60)
    let second = Int(seconds - hours * 3600 - minutes * 60)

    return String(format: "%02d", hours) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", second)
}
