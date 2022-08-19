//
//  Alert.swift
//  Tonic
//

import Foundation
import UIKit

/// Action alias with title and style.
typealias Action = (title: String, style: UIAlertAction.Style)

/// Alert model.
struct Alert {

    /// Alert title.
    let title: String?
    
    /// Alert message.
    let message: String?
    
    /// Alert action.
    var action: Action = Alert.okAction
    
    /// Alert action handler.
    var actionHandler: (() -> Void)? = nil
}

extension Alert {
    
    /// Predifined default action that provides `Ok` as a button.
    static var okAction: Action {
        ("Ok", .default)
    }
}
