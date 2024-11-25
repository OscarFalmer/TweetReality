//
//  MathsBasic.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 16/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit

func degreesToRadians(_ degrees: CGFloat) -> CGFloat{
    return (degrees * CGFloat.pi) / 180
}

func radiansToDegrees(_ radians: CGFloat) -> CGFloat{
    return radians * 180 / CGFloat.pi
}

func distanceTwoPointsWithDegrees(angle: CGFloat, radius: CGFloat) -> CGFloat{
    if angle == 0{
        return 0
    }
    
    return 2 * radius * sinus(angle/2)
}

func sinus(_ alpha: CGFloat) -> CGFloat{
    return CGFloat(sinf(Float(alpha * CGFloat.pi / 180.0)))
}

func cosinus(_ alpha: CGFloat) -> CGFloat{
    return CGFloat(cosf(Float(alpha * CGFloat.pi / 180.0)))
}

func tang(_ alpha: CGFloat) -> CGFloat{
    return CGFloat(tanf(Float(alpha * CGFloat.pi / 180.0)))
}

