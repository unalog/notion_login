//
//  UIImage+Extension.swift
//  MyNotion
//
//  Created by una on 2021/10/18.
//

import Foundation
import UIKit

extension UIImage {
    
    func changeSmallImage(size: CGSize) -> UIImage {
        guard self.size.width > 0 , self.size.height > 0 else { return self }
        
        let widthScale: CGFloat =  size.width / self.size.width
        let heightScale: CGFloat = size.height / self.size.height
        let scale = min(widthScale, heightScale)
        
        if scale > 1 {
            return self
        }
        
        let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
