//
//  Macro.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import Foundation
import UIKit

let screenBounds = UIScreen.mainScreen().bounds
let screenSize   = screenBounds.size
let screenWidth  = screenSize.width
let screenHeight = screenSize.height
let gridWidth : CGFloat = (screenWidth-10)*0.5      // iPhone 6 is 1 pixel off........
let navigationHeight : CGFloat = 44.0
let statubarHeight : CGFloat = 20.0
let navigationHeaderAndStatusbarHeight : CGFloat = navigationHeight + statubarHeight

let xPadding : CGFloat = 16.0
let yPadding : CGFloat = 10.0

let mainColor : UIColor = UIColor(red: 41.0/255.0, green: 45.0/255.0, blue: 53.0/255.0, alpha: 0.8)