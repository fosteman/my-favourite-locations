//
//  HudView.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-14.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import Foundation
import UIKit

class HudView: UIView {
    var text = ""
    
    // Convinience constructor - class method
    class func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        
        // hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        
        hudView.show(animated: animated)
        return hudView
    }
    
    // render
    override func draw(_ rect: CGRect) {
        let boxHeight: CGFloat = 96
        let boxWidth: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        if let image = UIImage(named: "Checkmark") {
          let imagePoint = CGPoint(
            x: center.x - round(image.size.width / 2),
            y: center.y - round(image.size.height / 2) - boxHeight / 8
            )
            image.draw(at: imagePoint)
        }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let textSize = text.size(withAttributes: attributes)
        let textPoint = CGPoint(
        x: center.x - round(textSize.width / 2),
        y: center.y - round(textSize.height / 2) + boxHeight / 4
        )
        text.draw(at: textPoint, withAttributes: attributes)
    }
    
    //MARK: methods
    
    func show(animated:Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    func hide() {
        superview?.isUserInteractionEnabled = true
        removeFromSuperview()
    }
}