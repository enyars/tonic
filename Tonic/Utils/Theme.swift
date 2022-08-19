//
//  Theme.swift
//  Tonic
//

import Foundation
import UIKit
import SwiftUI

extension UIFont {
    
    /// Initializes font from name, if not found will throw exception at runtime.
    convenience init(from name: String, size: CGFloat) {
        self.init(name: name, size: size)!
    }
    
    static func cocktailBoldWithSize(size: CGFloat) -> UIFont {
        return UIFont(from: "GopherText-Bold", size: size)
    }
    
    static func cocktailMediumWithSize(size: CGFloat) -> UIFont {
        return UIFont(from: "GopherText-Medium", size: size)
    }
}
