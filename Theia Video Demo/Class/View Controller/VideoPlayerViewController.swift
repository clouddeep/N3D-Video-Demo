//
//  VideoPlayerViewController.swift
//  Theia Video Demo
//
//  Created by Tuan Shou Cheng on 2017/12/21.
//  Copyright © 2017年 Tuan Shou Cheng. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {
    
    var videoAsset: AVAsset?
    
    let playerViewController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.addChildViewController(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.didMove(toParentViewController: self)
        
        playerViewController.view.frame = view.bounds
        
        if let video = videoAsset {
            let item = AVPlayerItem(asset: video)
            playerViewController.player = AVPlayer(playerItem: item)
        }
    }

    
}

extension VideoPlayerViewController {
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if TVDProfile.shared.deviceLandscapeOrientation == .left {
                return .landscapeLeft
            } else {
                return .landscapeRight
            }
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            if TVDProfile.shared.deviceLandscapeOrientation == .left {
                return .landscapeLeft
            } else {
                return .landscapeRight
            }
        }
    }
}
