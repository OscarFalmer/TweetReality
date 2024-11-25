//
//  GeometryTransformation.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 16/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit

func CircleCoordinates(radiusFromUser: CGFloat, angle: CGFloat, radiusOnCircle: CGFloat) -> (CGFloat, CGFloat, CGFloat){
    
    let x = radiusOnCircle * cosinus(angle)
    let y = radiusOnCircle * sinus(angle)
    let z = radiusFromUser
    
    return (x, y, z)
}


func SphericalToCarthesianCoordinates(radius: CGFloat, xAngle: CGFloat, yAngle: CGFloat) -> (CGFloat, CGFloat, CGFloat){
    
    let yAngleBis = 90-yAngle
    
    let x = radius * sinus(yAngleBis) * cosinus(xAngle)
    let y = radius * sinus(yAngleBis) * sinus(xAngle)
    let z = radius * cosinus(yAngleBis)
    
    return (x, y, z)
    
}

func CarthesianToSphericalCoordinates(x: Float, y: Float, z:Float) -> (Float, CGFloat, CGFloat){
    
    let r = (x*x + y*y + z*z).squareRoot()
    var xAngle = CGFloat(atanf(y/x))
    let alright = (x*x + y*y).squareRoot() / z
    var yAngle = CGFloat(atanf(alright))
    
    xAngle = radiansToDegrees(xAngle)
    yAngle = radiansToDegrees(yAngle)
    
    return (r, xAngle, yAngle)
    
}

func newEulerAngle(_ beta: CGFloat) -> CGFloat{ //beta : angle enDegrees
    
    if beta == 0{
        return 0
    }
    
    let betaPrime = (180.0 - beta) / 2.0
    let alphaPrime = 90.0 - betaPrime
    let alpha = -2*alphaPrime
    
    return degreesToRadians(alpha)
}
