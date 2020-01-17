//
//  UIImage+Resize.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-17.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resized(withBounds bounds: CGSize) -> UIImage {
        // aspect fill
        let newSize = CGSize(width: bounds.width, height: bounds.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
