//
//  LiteViewController.swift
//  GoMoreR
//
//  Created by Sophie Liang on 2019/5/16.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit

class LiteViewController: UIViewController {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSettingButton(_ sender: UIButton) {
    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        self.performSegue(withIdentifier: "LiteToWorkout", sender: nil)
    }
    
    var mockData: [(distance: Double, time: Int, date: Date, stamina: CGFloat)] = {
        var arr: [(distance: Double, time: Int, date: Date, stamina: CGFloat)] = []
        for i in 0...5 {
            let date = Date().adding(.day, value: -i)
            let date2 = date.adding(.minute, value: Int.random(in: 0...60))
            let finalDate = date2.adding(.hour, value: Int.random(in: 0...5))
            arr.append((distance: Double.random(in: 1...10),
                        time: Int.random(in: 30...4000),
                        date: finalDate,
                        stamina: CGFloat.random(in: 0.05...0.99)))
        }
        return arr
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    

}

extension LiteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RecordTableViewCell.self, for: indexPath)
        let thisData = mockData[indexPath.row]
        cell.setLabel(data: thisData)
        return cell
    }
    
    
}

extension LiteViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

