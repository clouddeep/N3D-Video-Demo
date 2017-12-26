//
//  TVDProfile.swift
//  Theia Video Demo
//
//  Created by Tuan Shou Cheng on 2017/12/21.
//  Copyright © 2017年 Tuan Shou Cheng. All rights reserved.
//

import UIKit

class TVDProfile: NSObject {
    
    open class var shared: TVDProfile {
        get {
            return instance
        }
    }
    
    fileprivate static let instance = TVDProfile()
    
    var deviceLandscapeOrientation = VideoOrientation.right {
        didSet {
            if deviceLandscapeOrientation == .left {
                print("Left")
            } else {
                print("Right")
            }
        }
    }
    
    enum VideoOrientation {
        case right
        case left
    }
}
