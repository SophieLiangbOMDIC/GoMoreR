//
//  RecordTableViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import GMServerSDK

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
    
    func setLabel(data: GMSResponseWorkout) {
        distanceLabel.text = String(format: "%.2f", data.distanceKm ?? 0.0) + " km"
        timeLabel.text = secondsToString(data.timeSeconds ?? 0)
        let stamina = CGFloat(Double(data.staminaEnd ?? 0) / 100.00)/*CGFloat.random(in: 0...1)*/
        if stamina < 0 {
            staminaLabel.text = "計算錯誤"
        } else {
            staminaLabel.text = String(format: "%.f", stamina * 100) + "%"
        }
        dateLabel.text = (data.timeStart ?? Date()).string(withFormat: "yyyy.MM.dd HH:mm")
        workoutIdLabel.text = data.userWorkoutId?.string ?? ""
        
        guard stamina >= 0 else { return }
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

