//
//  GlobalFunctions.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import Foundation

//Beispiel: macht auch 12.5 --> "12° 30.00'"
func degreesMinutes(_ x: Double) -> String {
    let remainder = x.truncatingRemainder(dividingBy: 1)
    let minutes = abs(remainder * 60)
    return String(format: "%d° %.2f'", Int(x),  minutes)
}
