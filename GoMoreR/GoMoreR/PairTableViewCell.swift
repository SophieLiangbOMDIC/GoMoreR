//
//  PairTableViewCell.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class PairTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBAction func tapConnectButton(_ sender: UIButton) {
        connectButton.isSelected = !connectButton.isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 8
        connectButton.layer.cornerRadius = 8
        connectButton.setTitle("連線", for: .normal)
        connectButton.setTitleColor(UIColor(red: 28, green: 45, blue: 76, alpha: 0.85), for: .normal)

        connectButton.setTitle("已連線", for: .selected)
        connectButton.setTitleColor(UIColor(red: 28, green: 45, blue: 76, alpha: 0.85), for: .selected)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
