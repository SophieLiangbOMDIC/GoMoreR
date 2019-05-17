//
//  GMMainViewController.swift
//  GoMoreR
//
//  Created by JakeChang on 2019/5/10.
//  Copyright © 2019 jake. All rights reserved.
//

import UIKit
import Intents

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let ID = "MainViewController"
    let customTransitionDelegate = TransitioningDelegate()
    var blurView: UIView?
    var pairViewController: PairViewController?
    var mockData: [(distance: Double, time: Int, level: CGFloat, stamina: CGFloat)] = {
        var arr: [(distance: Double, time: Int, level: CGFloat, stamina: CGFloat)] = []
        for i in 0...5 {
            arr.append((distance: Double.random(in: 1...10),
                        time: Int.random(in: 30...300),
                        level: CGFloat.random(in: 0...50),
                        stamina: CGFloat.random(in: 0.05...0.99)))
        }
        return arr
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .custom
        transitioningDelegate = customTransitionDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(nibWithCellClass: MainCollectionViewCell.self)
        
        INPreferences.requestSiriAuthorization { (status) in
            switch status {
            case .authorized:
                print("authorized")
            default:
                print("not authorized")
            }
        }
    }

    func showBlur() {
        if blurView == nil {
            blurView = UIView(frame: view.frame)
            blurView = blurView?.blur()
        }
        if let blur = blurView {
            blur.alpha = 0
            view.addSubview(blur)
            UIView.animate(withDuration: 0.3, animations: {
                blur.alpha = 1
            })
        }
    }
    
    func closeBlur() {
        if let blur = blurView {
            UIView.animate(withDuration: 0.3, animations: {
                blur.alpha = 0
            }, completion: { finished in
                blur.removeFromSuperview()
            })
        }
    }
    
    @IBAction func clickSidebarButton(_ sender: Any) {
        showBlur()
        if let vc = storyboard?.instantiateViewController(withClass: SidebarViewController.self) {
            self.addChild(vc)
            self.view.addSubview(vc.view)
        }
    }
    
    @IBAction func clickHistoryButton(_ sender: Any) {
        showBlur()
        
        if pairViewController == nil {
            pairViewController = storyboard?.instantiateViewController(withClass: PairViewController.self)
        }
        if let vc = pairViewController {
            addChild(vc)
            view.addSubview(vc.view)
            vc.tableView.frame = CGRect(x: 0,
                                        y: self.collectionView.frame.height,
                                        width: vc.tableView.frame.width,
                                        height: vc.tableView.frame.height)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
                vc.tableView.frame = CGRect(x: 0,
                                            y: self.collectionView.frame.minY,
                                            width: vc.tableView.frame.width,
                                            height: vc.tableView.frame.height)
            }, completion: { finished in
            })
        }
    }
    
}

extension UIView {
    
    public func blur() -> UIView {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.frame
        
        return visualEffectView
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MainCollectionViewCell.self, for: indexPath)
        let thisData = mockData[indexPath.row]
        
        let height = self.collectionView.bounds.height * (thisData.stamina)
        let wave = WaveView(frame: CGRect(x: 0,
                                          y: self.collectionView.bounds.height - height,
                                          width: self.collectionView.bounds.width,
                                          height: height))
        
        cell.setLabel(data: thisData)
        
        if cell.waveView.subviews.count == 0 {
            cell.waveView.layoutSubviews()
            cell.waveView.addSubview(wave)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let date = Date().adding(.day, value: -indexPath.row)
        self.titleLabel.text = date.string(withFormat: "yyyy/MM/dd")
    }
}
