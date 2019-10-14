//
//  ArrowView.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import UIKit

@IBDesignable class ArrowView: UIView {
    
    //Farbe des Pfeils
    @IBInspectable var color:UIColor = .black
    
    //Richtung des Pfeils
    @IBInspectable var heading: Double = 0.0 {
        didSet{
            //bei Änderung neu zeichnen
            setNeedsDisplay()
        }
    }
    
    //Methode, um den Inhalt der View zu zeichnen
    override func draw(_ rect: CGRect) {
        let rad = heading / 180.0 * .pi;
        let side = min(frame.size.width, frame.size.height)
        let side2 = side/2
        let radius1 = side2 * 0.95 //Radius außen
        let radius2 = side2 * 0.25 //Radius innen
        let x0 = frame.size.width / 2
        let y0 = frame.size.height / 2
        
        let x1 = x0 + radius1 * CGFloat(cos(rad)) // Spitze
        let y1 = y0 - radius1 * CGFloat(sin(rad))
        let x2 = x0 + radius1 * CGFloat(cos(rad + .pi * 0.8))
        let y2 = y0 - radius1 * CGFloat(sin(rad + .pi * 0.8))
        let x3 = x0 + radius2 * CGFloat(cos(rad + .pi)) // unten
        let y3 = y0 - radius2 * CGFloat(sin(rad + .pi))
        let x4 = x0 + radius1 * CGFloat(cos(rad + .pi * 1.2))
        let y4 = y0 - radius1 * CGFloat(sin(rad + .pi * 1.2))
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: x1, y: y1))
        myBezier.addLine(to: CGPoint(x: x2, y: y2))
        myBezier.addLine(to: CGPoint(x: x3, y: y3))
        myBezier.addLine(to: CGPoint(x: x4, y: y4))
        myBezier.close()
        color.setFill()
        myBezier.fill()
        color.setStroke()
        myBezier.stroke()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
