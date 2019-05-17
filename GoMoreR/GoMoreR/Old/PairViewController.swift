//
//  PairViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class PairViewController: UIViewController {
    
    var bts: [[String]] = [["COD_BAND", "CORO PACE 663B02", "COD_WATCH"], ["Stryd"], ["Bike_Sensor"]]

    @IBOutlet weak var tableView: UITableView!
    @IBAction func tapCancelButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.minY - 50, width: self.tableView.frame.width, height: self.tableView.frame.height)
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            let parent = self.parent as! MainViewController
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: 0, y: parent.collectionView.frame.height, width: self.tableView.frame.width, height: self.tableView.frame.height)
            }, completion: { finished in
                self.view.removeFromSuperview()
                self.removeFromParent()
                parent.closeBlur()
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
}

extension PairViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PairTableViewCell.self, for: indexPath)
        cell.nameLabel.text = bts[indexPath.section][indexPath.row]
        return cell
    }
    
}

extension PairViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "心率"
        case 1: return "功率計"
        case 2: return "頻踏器"
        default: return nil
        }
    }
}
