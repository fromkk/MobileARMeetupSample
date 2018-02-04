//
//  BinaryFloatingPoint+Extensions.swift
//  ARKitSample
//
//  Created by Kazuya Ueoka on 2018/02/03.
//  Copyright © 2018 Timers, Inc. All rights reserved.
//

import Foundation

extension BinaryFloatingPoint {
    var toRadians: Self { return self * .pi / 180.0 }
    var toDegrees: Self { return self * 180.0 / .pi }
}
