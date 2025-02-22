//
//  TabBar.swift
//  QrCodeApp
//
//  Created by Rumeysa Tokur on 21.02.2025.
//

import UIKit

@IBDesignable
class CustomTabBar: UITabBar {
    
    private var shapeLayer: CAShapeLayer?

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        addShape()
    }
    
    // MARK: - Custom Shape Methods
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0,
                                         height: 4)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowOpacity = 0.2

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer,
                                       with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer,
                                      at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    // MARK: - Shape Path Creation
    private func createPath() -> CGPath {
        let height: CGFloat = 50.0
        let width = self.frame.width
        let centerWidth = width / 2

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - height * 1.5,
                                 y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth,
                                  y: height),
                      controlPoint1: CGPoint(x: centerWidth - 40,
                                             y: 0),
                      controlPoint2: CGPoint(x: centerWidth - 35,
                                             y: height))
        path.addCurve(to: CGPoint(x: centerWidth + height * 1.5,
                                  y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35,
                                             y: height),
                      controlPoint2: CGPoint(x: centerWidth + 40,
                                             y: 0))
        
        path.addLine(to: CGPoint(x: width,
                                 y: 0))
        path.addLine(to: CGPoint(x: width,
                                 y: self.frame.height))
        path.addLine(to: CGPoint(x: 0,
                                 y: self.frame.height))
        path.close()

        return path.cgPath
    }
}
